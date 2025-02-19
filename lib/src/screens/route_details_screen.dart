import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/providers/providers.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;

class RouteDetailsScreen extends StatefulWidget {
  static const routeName = 'route_details_screen';
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
      return const Scaffold(
        body: Center(
          child: Text('Error: No se proporcionaron argumentos válidos.'),
        ),
      );
    }
    final route = args;

    return Scaffold(
      floatingActionButton: _ButtonStartRoute(route: route),
      bottomNavigationBar: const CustomNavigationBar(),
      body: Stack(
        children: [
          // Fondo con WavesWidget
          const WavesWidget(),

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

// Método para construir la primera pantalla (Información de la ruta)
  Widget _buildFirstScreen(vilaModels.Route route) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            options: ImageCarousel.carouselOptions(),
            itemCount: route.places.length,
            itemBuilder: (context, index, realIndex) {
              var place = route.places[index];
              return ImageCarousel(article: place);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(route.description),
          ),
          const Divider(),
        ],
      ),
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

class _ButtonStartRoute extends StatelessWidget {
  const _ButtonStartRoute({
    required this.route,
  });

  final vilaModels.Route route;

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    // final openRouteService = OpenRouteService();

    return FloatingActionButton(
      onPressed: () async {
        // final routeRequesAPI = await openRouteService.getOpenRouteByRoute(route, 'foot-walking');

        uiProvider.selectedMenuOpt = 2;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MapScreen(route: route), 
          ),
        );
        // Navigator.pushReplacementNamed(context, MapScreen.routeName, arguments: route);
      },
      tooltip: 'Iniciar ruta',
      child: const Icon(Icons.map),
    );
  }
}
