import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;

class RouteDetailsScreen extends StatelessWidget {
  static final routeName = 'route_details_screen';
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vilaModels.Route route = ModalRoute.of(context)!.settings.arguments as vilaModels.Route;

    return Scaffold(
      body: Stack(
        children: [
          WavesWidget(),
          Column(
            children: [
              BarScreenArrow(labelText: route.name, arrowBack: true),
              Center(
                child: Text('${route.name}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
