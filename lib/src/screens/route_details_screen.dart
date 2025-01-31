import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;
import 'package:latlong2/latlong.dart';

class RouteDetailsScreen extends StatefulWidget {
  static final routeName = 'route_details_screen';
  const RouteDetailsScreen({super.key});

  @override
  _RouteDetailsScreenState createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! vilaModels.Route) {
      // Si los argumentos no son válidos, volver a la pantalla anterior
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
      return Scaffold(
        body: Center(
          child: Text('Error: No se proporcionaron argumentos válidos.'),
        ),
      );
    }
    final route = args as vilaModels.Route;

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      body: Stack(
        children: [
          // Fondo con WavesWidget
          WavesWidget(),

          // Contenido principal
          Column(
            children: [
              // Barra superior con flecha de retroceso
              BarScreenArrow(labelText: route.name, arrowBack: true),

              // Pestañas
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Mapa'),
                  Tab(text: 'Lugares'),
                ],
              ),

              // Área deslizable con TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Primera pantalla
                    _buildFirstScreen(route),

                    // Segunda pantalla
                    _buildSecondScreen(route),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Método para construir la primera pantalla (Mapa)
  Widget _buildFirstScreen(vilaModels.Route route) {
    // Crear una lista de coordenadas de los lugares
    List<LatLng> coordinates = route.places.map((place) {
      return LatLng(place.coordinate.latitude, place.coordinate.longitude);
    }).toList();

    // Calcular los límites del mapa (latitudes y longitudes mínimas y máximas)
    LatLngBounds bounds = LatLngBounds.fromPoints(coordinates);

    // Crear el controlador del mapa
    MapController mapController = MapController();

    return FlutterMap(
      mapController: mapController, // Asignamos el controlador al mapa
      options: MapOptions(
        initialCenter: LatLng(
          route.places.first.coordinate.latitude,
          route.places.first.coordinate.longitude,
        ), // Centrado en el primer lugar de la ruta
        initialZoom: 13.0, // Nivel de zoom inicial
        minZoom: 10.0, // Mínimo nivel de zoom
        maxZoom: 18.0, // Máximo nivel de zoom
       onMapReady: () {
        // Calcular el centro de los límites
        final center = bounds.center;

        // Ajustar el zoom para que todos los lugares sean visibles
        mapController.move(center, 13.0); // Usa un valor de zoom fijo o calcula el adecuado
      },
    ),
      children: [
        // Capa de tiles (mapa base)
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'], // Subdominios para cargar los tiles
          userAgentPackageName:
              'com.example.vila_tour_pmdm', // User-Agent para OpenStreetMap
        ),
        // Capa de marcadores
        MarkerLayer(
          markers: route.places.map((place) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point:
                  LatLng(place.coordinate.latitude, place.coordinate.longitude),
              child: Icon(
                Icons.place, // Puedes usar cualquier ícono o imagen
                color: Colors.red, // Color del marcador
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Método para construir la segunda pantalla (Lista de lugares)
  Widget _buildSecondScreen(vilaModels.Route route) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: route.places.length,
            itemBuilder: (context, index) {
              return ArticleBox(article: route.places[index]);
            },
          ),
        ],
      ),
    );
  }
}
