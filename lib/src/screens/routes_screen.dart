import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;
import 'package:vila_tour_pmdm/src/services/services.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';

class RoutesScreen extends StatefulWidget {
  static const routeName = 'routes_screen';
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<vilaModels.Route>> _routesFuture;
  List<vilaModels.Route> _filteredRoutes = [];
  String _selectedAttribute = 'name'; // Atributo inicial para filtrar

  @override
  void initState() {
    super.initState();
    final routeService = RouteService();
    _routesFuture = routeService.getRoutes();
  }

  void _filterRoutes(String query, List<vilaModels.Route> routes) {
    setState(() {
      if (query.isEmpty) {
        _filteredRoutes = routes;
      } else {
        _filteredRoutes = routes.where(
          (route) {
            final value = _getAttributeValue(route, _selectedAttribute);
            return value != null &&
                value.toLowerCase().contains(query.toLowerCase());
          },
        ).toList();
      }
    });
  }

  String? _getAttributeValue(vilaModels.Route route, String attribute) {
    switch (attribute) {
      case 'name':
        return route.name;
      default:
        return null;
    }
  }

  void _showFilterOptions() {
    final Map<String, String> filterOptions = {
      'Nombre': 'name',
    };

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: filterOptions.keys.map((label) {
                final attribute = filterOptions[label]!;
                return CheckboxListTile(
                  title: Text(label), // Muestra el nombre en español
                  value: _selectedAttribute == attribute,
                  onChanged: (isSelected) {
                    setState(() {
                      // Actualiza el estado de las opciones
                      _selectedAttribute =
                          isSelected ?? false ? attribute : _selectedAttribute;

                      // Aplicar el filtro
                      _routesFuture.then((routes) {
                        _filterRoutes(searchController.text, routes);
                      });
                    });

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavigationBar(),
      body: Stack(
        children: [
          const Positioned.fill(
            child: WavesWidget(),
          ),
          Column(
            children: [
              BarScreenArrow(labelText: 'Rutas', arrowBack: true),
              SearchBox(
                hintText:  AppLocalizations.of(context).translate('searchRoutes'),
                controller: searchController,
                onChanged: (text) {
                  _routesFuture.then((routes) => _filterRoutes(text, routes));
                },
                onFilterPressed: _showFilterOptions,
              ),
              Expanded(
                child: FutureBuilder<List<vilaModels.Route>>(
                  future: _routesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(AppLocalizations.of(context).translate('noRoutes')));
                    } else {
                      final routes = _filteredRoutes.isEmpty
                          ? snapshot.data!
                          : _filteredRoutes;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          // TODO: hacer un contenedor con la información de la ruta
                          return RouteBox(route: route);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

