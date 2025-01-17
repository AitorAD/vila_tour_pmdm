import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/places_provider.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

class MapScreen extends StatefulWidget {
  static final routeName = 'map_screen';

  static final Map<String, IconData> categoryIcons = {
    'PLAYA': Icons.beach_access_rounded,
    'PARQUE': Icons.park_rounded,
    'RESTAURANTE': Icons.restaurant_rounded,
    'HOTEL': Icons.hotel_rounded,
    'MONUMENTO': Icons.account_balance_rounded,
    'MUSEO': Icons.museum_rounded,
    'IGLESIA': Icons.church_rounded,
    'CASTILLO': Icons.castle_rounded,
  };

  static List<String> selectedCategories = List.from(categoryIcons.keys);
  static List<Place> places = [];

  @override
  State<MapScreen> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() async {
    try {
      final placeService = PlaceService();
      final places = await placeService.getPlaces();
      Provider.of<PlacesProvider>(context, listen: false).setPlaces(places);

      setState(() {
        _markers = places.where((place) => MapScreen.selectedCategories.contains(place.categoryPlace.name)).map((place) {
          IconData iconData = MapScreen.categoryIcons[place.categoryPlace.name] ?? Icons.location_on;
          return Marker(
            point: LatLng(place.coordinate.latitude, place.coordinate.longitude),
            child: Icon(
              iconData,
              color: Colors.lightBlue,
              size: 30.0,
            ),
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar los lugares: $e');
    }
  }

  void _updateMarkers() {
    setState(() {
      _loadMarkers();
    });
  }

  void _centerMapOnUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(38.509430, -0.230211),
              initialZoom: 13.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) => _popupController.hideAllPopups(),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'vila_tour',
              ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  markers: _markers,
                  popupController: _popupController,
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker) {
                      final place = Provider.of<PlacesProvider>(context, listen: false).places.firstWhere(
                        (p) => p.coordinate.latitude == marker.point.latitude && p.coordinate.longitude == marker.point.longitude,
                        orElse: () => Place.nullPlace(),
                      );
                      return Container(
                        width: 300,
                        height: 170,
                        child: place.id == -1
                            ? const Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Lugar no encontrado'),
                                ),
                              )
                            : ArticleBox(article: place),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            top: false,
            minimum: EdgeInsets.only(top: 15),
            child: SearchBoxFiltered(updateMarkers: _updateMarkers),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _centerMapOnUser,
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class SearchBoxFiltered extends StatelessWidget {
  final VoidCallback updateMarkers;

  const SearchBoxFiltered({super.key, required this.updateMarkers});

  @override
  Widget build(BuildContext context) {
    return SearchBox(
      hintText: "Buscar lugar",
      controller: TextEditingController(),
      onChanged: (value) {},
      onFilterPressed: () {
        _showFilterMenu(context);
      },
    );
  }

  Future<String?> _showFilterMenu(BuildContext context) {
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      items: MapScreen.categoryIcons.entries.map(
        (entry) {
          return PopupMenuItem<String>(
            child: Row(
              children: [
                StatefulBuilder(
                  builder: (context, setState) => Checkbox(
                    value: MapScreen.selectedCategories.contains(entry.key),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          MapScreen.selectedCategories.add(entry.key);
                        } else {
                          MapScreen.selectedCategories.remove(entry.key);
                        }
                      });
                      updateMarkers();
                    },
                  ),
                ),
                Icon(entry.value),
                SizedBox(width: 5),
                Text(entry.key),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
