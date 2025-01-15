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
  static final routeName = 'map_screen';
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
                SearchBox(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                     final mapBodyState = context.findAncestorStateOfType<_MapBodyState>();
                      mapBodyState?.getCurrentLocation();
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


  Future<void> getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  } catch (e) {
    print('Error al obtener la ubicación actual: $e');
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
