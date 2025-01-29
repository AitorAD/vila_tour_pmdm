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
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class MapScreen extends StatefulWidget {
  static const routeName = 'map_screen';

  static final Map<String, IconData> categoryIcons = {
    'PLAYA': Icons.beach_access_rounded,
    'PARQUE': Icons.park_rounded,
    'RESTAURANTE': Icons.restaurant_rounded,
    'HOTEL': Icons.hotel_rounded,
    'MONUMENTO': Icons.account_balance_rounded,
    'MUSEO': Icons.museum_rounded,
    'IGLESIA': Icons.church_rounded,
  };

  static final Map<String, Color> categoryColors = {
    'PLAYA': const Color.fromARGB(255, 243, 152, 33),
    'PARQUE': Colors.green,
    'RESTAURANTE': const Color.fromARGB(255, 240, 20, 4),
    'HOTEL': const Color.fromARGB(255, 45, 10, 204),
    'MONUMENTO': const Color.fromARGB(255, 180, 97, 3),
    'MUSEO': const Color.fromARGB(255, 125, 7, 223),
    'IGLESIA': Colors.brown,
  };

  static List<String> selectedCategories = List.from(categoryIcons.keys);
  static List<Place> places = [];

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  List<Marker> _markers = [];
  bool _showList = false;

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
              color: MapScreen.categoryColors[place.categoryPlace.name] ?? Colors.red,
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
  List<Place> _places = []; // Datos iniciales
  List<Place> _filteredPlaces = [];
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

  void _onPlaceTap(Place place) {
    _controller.text = place.name;
    setState(() {
      _showList = false;
      _selectedMarkerId =
          place.id.toString(); // Asocia el marcador seleccionado
    });
    widget.mapController.move(
      LatLng(place.coordinate.latitude, place.coordinate.longitude),
      15.0,
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
