import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/providers/places_provider.dart';
import 'package:vila_tour_pmdm/src/services/place_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

class MapScreen2 extends StatefulWidget {
  // Ruta de la pantalla
  static final routeName = 'map_screen';

  // Listade tipos de lugares y sus iconos
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

  // Lista de categorías seleccionadas (inicialmente todas seleccionadas)
  static List<String> selectedCategories = List.from(categoryIcons.keys);

  // Lista estatica de lugares
  static List<Place> places = [];

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  @override
  Widget build(BuildContext context) {
    PlaceService placeService = PlaceService();
    return Scaffold(
      body: FutureBuilder<List<Place>>(
          future: placeService.getPlaces(),
          builder: (context, snapshot) {
            Provider.of<PlacesProvider>(context, listen: false)
                .setPlaces(snapshot.data ?? []);
            return Stack(
              children: [
                _MapBody(),
                SafeArea(
                  top: false,
                  minimum: EdgeInsets.only(top: 15),
                  child: SearchBoxFiltered(),
                ),
                CenterMap(),
              ],
            );
          }),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

// Clase del boton para centrar el mapa
class CenterMap extends StatelessWidget {
  const CenterMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}

// Clase del cuadro de búsqueda
class SearchBoxFiltered extends StatelessWidget {
  const SearchBoxFiltered({
    super.key,
  });

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

  // Método para mostrar el menú de filtrado
  Future<String?> _showFilterMenu(BuildContext context) {
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          enabled: false,
          // Titulo del menú
          child: Text(
            'Opciones de Filtrado',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Checkbox de cada categoría
        ...MapScreen2.categoryIcons.entries.map(
          (entry) {
            return PopupMenuItem<String>(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Row(
                    children: [
                      Checkbox(
                        value:
                            MapScreen2.selectedCategories.contains(entry.key),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              MapScreen2.selectedCategories.add(entry.key);
                            } else {
                              MapScreen2.selectedCategories.remove(entry.key);
                            }
                          });
                        },
                      ),
                      Icon(entry.value),
                      SizedBox(width: 5),
                      Text(entry.key),
                    ],
                  );
                },
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}

// Clase del cuerpo del mapa
class _MapBody extends StatefulWidget {
  const _MapBody({Key? key}) : super(key: key);
  @override
  _MapBodyState createState() => _MapBodyState();
}

// Clase del estado del cuerpo del mapa
class _MapBodyState extends State<_MapBody> {
  List<Marker> _markers = [];
  MapController _mapController = MapController();
  PopupController _popupController = PopupController();

  @override
  void initState() {
    super.initState();
    // Acceder a los lugares desde el provider
    _loadMarkers();
  }

  void _loadMarkers() async {
    try {
      final places = Provider.of<PlacesProvider>(context, listen: false).places;
      print(places.length);
      setState(() {
        _markers = places.map((place) {
          // Obtener el icono de la categoría del lugar
          IconData iconData = MapScreen2.categoryIcons[place.categoryPlace.name]!;
          // Crear un marcador con el icono y la posición del lugar
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
                final place = MapScreen2.places.firstWhere(
                  (place) =>
                      place.coordinate.latitude == marker.point.latitude &&
                      place.coordinate.longitude == marker.point.longitude,
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
    );
  }
}
