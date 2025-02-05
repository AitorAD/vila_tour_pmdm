import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/providers/places_provider.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/services/services.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:flutter_compass/flutter_compass.dart';

class MapScreen extends StatefulWidget {
  vilaModels.Route? route;
  static const routeName = 'map_screen';

  static final Map<String, IconData> categoryIcons = {
    'Playa': Icons.beach_access_rounded,
    'Montaña': Icons.terrain_rounded,
    'Museo': Icons.museum_rounded,
    'Parque': Icons.park_rounded,
    'Centro histórico': Icons.history_edu_rounded,
    'Monumento': Icons.account_balance_rounded,
    'Jardin': Icons.nature_rounded,
    'Iglesia': Icons.church_rounded,
    'Castillo': Icons.castle_rounded,
    'Centro cultrular': Icons.celebration_rounded,
    'Zona arqueologica': Icons.pages_outlined,
    'Teatro': Icons.theater_comedy_rounded,
    'Mercado': Icons.shopping_basket_rounded,
    'Paseo Marítimo': Icons.anchor_rounded,
    'Reserva Natural': Icons.nature_people_rounded,
    'Mirador': Icons.camera_alt_rounded,
    'Cueva': Icons.landscape_rounded,
    'Lago': Icons.water_rounded,
    'Puente': Icons.linear_scale_outlined,
    'Faro': Icons.lightbulb_circle_rounded,
    'Restaurante': Icons.restaurant_outlined,
    'Hotel': Icons.hotel_rounded,
    'Bar': Icons.restaurant_menu_outlined,
    'Cafeteria': Icons.coffee_rounded,
    'Spa': Icons.spa_rounded
  };

  static final Map<String, Color> categoryColors = {
    'Playa': const Color.fromARGB(255, 243, 152, 33),
    'Montaña': const Color.fromARGB(255, 155, 41, 12),
    'Museo': const Color.fromARGB(255, 143, 138, 132),
    'Parque': const Color.fromARGB(255, 5, 138, 44),
    'Centro histórico': const Color.fromARGB(255, 243, 152, 33),
    'Monumento': const Color.fromARGB(255, 243, 152, 33),
    'Jardin': const Color.fromARGB(255, 243, 152, 33),
    'Iglesia': const Color.fromARGB(255, 243, 152, 33),
    'Castillo': const Color.fromARGB(255, 243, 152, 33),
    'Centro cultrular': const Color.fromARGB(255, 243, 152, 33),
    'Zona arqueologica': const Color.fromARGB(255, 243, 152, 33),
    'Teatro': const Color.fromARGB(255, 180, 9, 180),
    'Mercado': const Color.fromARGB(255, 243, 152, 33),
    'Paseo Marítimo': const Color.fromARGB(255, 243, 152, 33),
    'Reserva Natural': const Color.fromARGB(255, 243, 152, 33),
    'Mirador': const Color.fromARGB(255, 243, 152, 33),
    'Cueva': const Color.fromARGB(255, 243, 152, 33),
    'Lago': const Color.fromARGB(255, 243, 152, 33),
    'Puente': const Color.fromARGB(255, 243, 152, 33),
    'Faro': const Color.fromARGB(255, 243, 152, 33),
    'Restaurante': const Color.fromARGB(255, 243, 152, 33),
    'Hotel': const Color.fromARGB(255, 243, 152, 33),
    'Bar': const Color.fromARGB(255, 243, 152, 33),
    'Cafeteria': const Color.fromARGB(255, 243, 152, 33),
    'Spa': const Color.fromARGB(255, 243, 152, 33)
  };

  static List<String> selectedCategories = List.from(categoryIcons.keys);
  static List<vilaModels.Place> places = [];
  MapScreen({this.route});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  List<Marker> _markers = [];
  bool _showList = false;
  double? _heading;
  bool _isMapboxLayerActive = false;
  final openRouteService = OpenRouteService();
  vilaModels.ResponseRouteAPI? routeResponse;
  List<LatLng>? decodedGeometry;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _listenToCompass() {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading;
      });
    });
  }

  void _loadMarkers() async {
    try {
      final placeService = PlaceService();
      final places = await placeService.getPlaces();
      Provider.of<PlacesProvider>(context, listen: false).setPlaces(places);

      setState(() {
        _markers = places
            .where((place) =>
                MapScreen.selectedCategories.contains(place.categoryPlace.name))
            .map((place) {
          IconData iconData =
              MapScreen.categoryIcons[place.categoryPlace.name] ??
                  Icons.location_on;
          return Marker(
            point:
                LatLng(place.coordinate.latitude, place.coordinate.longitude),
            child: Icon(
              iconData,
              color: MapScreen.categoryColors[place.categoryPlace.name] ??
                  Colors.red,
              size: 30.0,
            ),
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar los lugares: $e');
    }
  }

  void loadRouteResponse() async {
    if (widget.route != null) {
      routeResponse = await openRouteService.getOpenRouteByRoute(
          widget.route!, 'foot-walking');
    }
    decodedGeometry =
        await _decodeGeometry(routeResponse!.routes.first.geometry);
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

  // Función para decodificar la cadena `geometry` usando flutter_polyline_points
  Future<List<LatLng>> _decodeGeometry(String geometry) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints =
        await polylinePoints.decodePolyline(geometry);

    // Convertir los puntos decodificados a una lista de LatLng
    List<LatLng> latLngPoints = decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return latLngPoints;
  }

  @override
  Widget build(BuildContext context) {
    //final vilaModels.Route? route = ModalRoute.of(context)?.settings.arguments as vilaModels.Route;

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
                urlTemplate: _isMapboxLayerActive
                    ? 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (widget.route != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: decodedGeometry!,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: _markers,
                  popupController: _popupController,
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker) {
                      final place =
                          Provider.of<PlacesProvider>(context, listen: false)
                              .places
                              .firstWhere(
                                (p) =>
                                    p.coordinate.latitude ==
                                        marker.point.latitude &&
                                    p.coordinate.longitude ==
                                        marker.point.longitude,
                                orElse: () => vilaModels.Place.nullPlace(),
                              );

                      return Container(
                        width: 300,
                        height: 170,
                        child: place.id == -1
                            ? Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(AppLocalizations.of(context)
                                      .translate('place404')),
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
            child: SearchBoxFiltered(
              mapController: _mapController,
              popupController: _popupController,
              updateMarkers: _updateMarkers,
              onTap: () {
                setState(() {
                  _showList = !_showList;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 110.0, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isMapboxLayerActive = !_isMapboxLayerActive;
                      });
                    },
                    backgroundColor: vilaBlueColor(),
                    focusColor: Colors.white,
                    child: Icon(Icons.layers_outlined, color: Colors.white),
                  ),
                  SizedBox(height: 10), // Espacio entre los botones
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: vilaBlueColor(),
                focusColor: Colors.white,
                onPressed: _centerMapOnUser,
                child: Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class SearchBoxFiltered extends StatefulWidget {
  final VoidCallback updateMarkers;
  final VoidCallback onTap;
  final MapController mapController;
  final PopupController popupController;

  const SearchBoxFiltered(
      {super.key,
      required this.updateMarkers,
      required this.onTap,
      required this.mapController,
      required this.popupController});

  @override
  State<SearchBoxFiltered> createState() => _SearchBoxFilteredState();
}

class _SearchBoxFilteredState extends State<SearchBoxFiltered> {
  PlaceService placeService = PlaceService();
  TextEditingController _controller = TextEditingController();
  List<vilaModels.Place> _places = []; // Datos iniciales
  List<vilaModels.Place> _filteredPlaces = [];
  bool _showList = false;
  String? _selectedMarkerId; // Variable para el marcador seleccionado

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _controller.addListener(_filterPlaces);
    print(_places);
  }

  void _loadPlaces() async {
    _places = await placeService.getPlaces();
    setState(() {
      _filteredPlaces = _places; // Inicializamos con todos los lugares
    });
  }

  void _filterPlaces() {
    setState(() {
      // Filtrar los lugares según el texto ingresado y las categorías seleccionadas
      _filteredPlaces = _places
          .where((place) =>
              place.name
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) &&
              MapScreen.selectedCategories.contains(place.categoryPlace.name))
          .toList();

      // Mostrar u ocultar la lista dependiendo del contenido
      _showList = _controller.text.isNotEmpty && _filteredPlaces.isNotEmpty;
    });
  }

  void _onPlaceTap(vilaModels.Place place) {
    _controller.text = place.name;
    setState(() {
      _showList = false;
      _selectedMarkerId =
          place.id.toString(); // Asocia el marcador seleccionado
    });
    widget.mapController.moveAndRotate(
      LatLng(place.coordinate.latitude, place.coordinate.longitude),
      15.0,
      0.0,
    );
    // Activa el popup del marcador correspondiente
    widget.popupController.togglePopup(
      Marker(
        point: LatLng(place.coordinate.latitude, place.coordinate.longitude),
        child:
            ArticleBox(article: place), // Añadir el parámetro 'child' requerido
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SearchBox(
            hintText: "Buscar lugar",
            controller: _controller,
            onChanged: (value) {
              _filterPlaces();
            },
            onFilterPressed: () {
              _showFilterMenu(context);
            },
            onTap: widget.onTap,
          ),
        ),
        if (_showList)
          Container(
            margin: EdgeInsets.only(top: 0),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.4, // Ajusta la altura según sea necesario
            ),
            child: ListView.builder(
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                final iconData =
                    MapScreen.categoryIcons[place.categoryPlace.name] ??
                        Icons.location_on;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                  elevation: 5,
                  child: ListTile(
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: vilaBlueColor()),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            iconData,
                            color: vilaBlueColor(),
                          ),
                        ),
                      ),
                      title: Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Text(
                        place.categoryPlace.name,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                      onTap: () => _onPlaceTap(place)),
                );
              },
            ),
          )
        else if (_controller.text.isNotEmpty && _filteredPlaces.isEmpty)
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text("No se encontraron lugares."),
            ),
          ),
      ],
    );
  }

  Future<String?> _showFilterMenu(BuildContext context) {
    return showMenu(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 100.0, 20.0, 0.0),
      items: MapScreen.categoryIcons.entries.map(
        (entry) {
          return PopupMenuItem<String>(
            child: Row(
              children: [
                StatefulBuilder(
                  builder: (context, setState) => Checkbox(
                    activeColor: vilaBlueColor(),
                    value: MapScreen.selectedCategories.contains(entry.key),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          MapScreen.selectedCategories.add(entry.key);
                        } else {
                          MapScreen.selectedCategories.remove(entry.key);
                        }
                      });
                      widget.updateMarkers();
                    },
                  ),
                ),
                Icon(entry.value),
                const SizedBox(width: 5),
                Text(entry.key),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
