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
                  Tab(text: 'Información'),
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
    return Container(
      child: Text(route.name),
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