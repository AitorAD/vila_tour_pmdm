import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class RouteBox extends StatelessWidget {
  const RouteBox({
    super.key,
    required this.route,
  });

  final vilaModels.Route route;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: routeBoxDecoration(),
      // decoration: defaultDecoration(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la ruta
          Text(
            route.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Origen y destino
          Text(
            'Origen: ${route.places.first.name}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            'Destino: ${route.places.last.name}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          // Número de lugares
          Text(
            'Lugares en la ruta: ${route.places.length}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          // Botón para ver más detalles
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteDetailsScreen.routeName,
                    arguments: route);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Ver más',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration routeBoxDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 111, 218, 209),
          Color.fromARGB(255, 172, 207, 228),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(2, 4),
        ),
      ],
    );
  }
}
