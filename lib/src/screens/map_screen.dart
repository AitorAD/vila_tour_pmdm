import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';


class MapScreen extends StatelessWidget {

  static final routeName = 'map_screen2';
  final List<String> _selectedOptions = [];

  final Map<String, IconData> categoryIcons = {
    'PLAYA': Icons.beach_access_rounded,
    'PARQUE': Icons.park_rounded,
    'RESTAURANTE': Icons.restaurant_rounded,
    'HOTEL': Icons.hotel_rounded,
    'MONUMENTO': Icons.account_balance_rounded,
    'MUSEO': Icons.museum_rounded,
    'IGLESIA': Icons.church_rounded,
    'CASTILLO': Icons.castle_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _MapBody(),
          SafeArea(
            top: false,
            minimum: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                SearchBox(
                  hintText: 'Buscar lugar',
                  controller: TextEditingController(),
                  onChanged: (value) {},
                  onFilterPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
                      items: <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          enabled: false,
                          child: Text(
                            'Opciones de Filtrado',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...categoryIcons.entries.map((entry) {
                          return PopupMenuItem<String>(
                            child: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: _selectedOptions.contains(entry.key),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedOptions.add(entry.key);
                                          } else {
                                            _selectedOptions.remove(entry.key);
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(width: 50),
                                    Icon(entry.value),
                                    Text(entry.key),
                                  ],
                                );
                              },
                            ),
                            value: entry.key,
                          );
                        }).toList(),
                      ],
                      elevation: 8.0,
                    ).then((value) {
                      if (value != null) {
                        // Manejar la opción seleccionada
                        print('Opción seleccionada: $value');
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                },
                child: Icon(Icons.gps_fixed),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _MapBody extends StatefulWidget {
  const _MapBody({super.key});

  @override
  State<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends State<_MapBody> {
  final PlaceService _placeService = PlaceService();
  List<Place> _places = [];
  List<Marker> _markers = [];
  PopupController _popupController = PopupController();

  static bool _isSatelliteView = false;
  MapController mapController = MapController();

  final Map<String, IconData> categoryIcons = {
    'PLAYA': Icons.beach_access_rounded,
    'PARQUE': Icons.park_rounded,
    'RESTAURANTE': Icons.restaurant_rounded,
    'HOTEL': Icons.hotel_rounded,
    'MONUMENTO': Icons.account_balance_rounded,
    'MUSEO': Icons.museum_rounded,
    'IGLESIA': Icons.church_rounded,
    'CASTILLO': Icons.castle_rounded,
  };

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() async {
    try {
      List<Place> places = await _placeService.getPlaces();
      setState(() {
        _places = places;
        _markers = _places.map((place) {
          IconData iconData = categoryIcons[place.categoryPlace.name]!;

          return Marker(
            point: LatLng(place.coordinate.latitude, place.coordinate.longitude),
            child: Icon(
              iconData,
              color: Color.fromARGB(255, 22, 183, 189),
              size: MediaQuery.of(context).size.width * 0.1,
            ),
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar los lugares: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(38.5227, -0.1981),
        initialZoom: 13.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) => _popupController.hideAllPopups(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'vila_tour',
        ),
        PopupMarkerLayer(
          options: PopupMarkerLayerOptions(
            markers: _markers,
            popupController: _popupController,
            popupDisplayOptions: PopupDisplayOptions(
              builder: (BuildContext context, Marker marker) {
                final place = _places.firstWhere(
                  (place) => place.coordinate.latitude == marker.point.latitude && place.coordinate.longitude == marker.point.longitude,
                  orElse: () => Place.nullPlace(),
                );
                return Container(
                  width: 300,
                  height: 170,
                  child: place.id == -1
                      ? Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
    );
  }
}