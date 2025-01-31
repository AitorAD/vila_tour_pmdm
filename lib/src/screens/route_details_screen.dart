import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vila_tour_pmdm/src/services/openRoutes_service.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;

class RouteDetailsScreen extends StatefulWidget {
  static final routeName = 'route_details_screen';
  const RouteDetailsScreen({super.key});

  @override
  _RouteDetailsScreenState createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MapController _mapController;
  List<LatLng> routePoints = []; // Se inicializa como lista vacía

  bool isLoading = false; // Estado de carga
  final OpenRouteService _routeService =
      OpenRouteService(); // Instancia del servicio

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _mapController = MapController();
    _loadRoute(); // Carga la ruta al iniciar la pantalla
  }

  // Método para cargar la ruta desde la API
  
Future<void> _loadRoute() async {
  setState(() {
    isLoading = true;
  });

  try {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is vilaModels.Route) {
      final route = args as vilaModels.Route;

      // Obtener la ruta desde la API
      final response = await _routeService.getRoute(route.places);
      final String encodedPolyline = response['geometry']; // Extrae la geometría

      print('Polyline recibida: $encodedPolyline');

      // Decodificar la polyline
      List<PointLatLng> decodedPoints = PolylinePoints().decodePolyline(encodedPolyline);
      List<LatLng> points = decodedPoints.map((point) => LatLng(point.latitude, point.longitude)).toList();

      if (points.isEmpty) {
        print('Error: La polyline decodificada está vacía.');
      }

      setState(() {
        routePoints = points;
      });
    }
  } catch (e) {
    print('Error al cargar la ruta: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
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
          WavesWidget(),
          Column(
            children: [
              BarScreenArrow(labelText: route.name, arrowBack: true),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Mapa'),
                  Tab(text: 'Lugares'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFirstScreen(route),
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (routePoints.isEmpty) {
      return Center(child: Text('No hay puntos de ruta disponibles.'));
    }

    // Calcular los límites del mapa con los puntos obtenidos de la API
    final bounds = LatLngBounds.fromPoints(routePoints);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: bounds.center,
        initialZoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        onMapReady: () {
          _mapController.move(bounds.center, 13.0);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.vila_tour_pmdm',
        ),
        // Dibujar la ruta con los puntos devueltos por la API
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints, // Se usa la ruta obtenida de la API
              color: Colors.blue,
              strokeWidth: 4.0,
            ),
          ],
        ),
        // Dibujar los marcadores de los lugares
        MarkerLayer(
          markers: route.places.map((place) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point:
                  LatLng(place.coordinate.latitude, place.coordinate.longitude),
              child: Icon(
                Icons.place,
                color: Colors.red,
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
            physics:
                NeverScrollableScrollPhysics(), // Evita conflictos con el scroll padre
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
