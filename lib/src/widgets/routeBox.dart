import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class RouteBox extends StatelessWidget {
  const RouteBox({super.key, required this.route});

  final vilaModels.Route route;

  @override
  Widget build(BuildContext context) {
    final String? firstImage =
        (route.places.isNotEmpty && route.places.first.images.isNotEmpty)
            ? route.places.first.images.first.path
            : null;

    final String? secondImage =
        (route.places.isNotEmpty && route.places.last.images.isNotEmpty)
            ? route.places.last.images.first.path
            : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      // decoration: routeBoxDecoration(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo inferior
          if (firstImage != null)
            ClipPath(
              clipper: TopDiagonalClipper(),
              child: FadeInImage(
                placeholder: const AssetImage('assets/logo.ico'),
                image: MemoryImage(decodeImageBase64(firstImage)),
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 50,
                ),
              ),
            ),

          // Imagen de fondo superior (clipeada en diagonal)
          if (secondImage != null)
            ClipPath(
              clipper: BottomDiagonalClipper(),
              child: FadeInImage(
                placeholder: const AssetImage('assets/logo.ico'),
                image: MemoryImage(decodeImageBase64(secondImage)),
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 50,
                ),
              ),
            ),

          // Añadir un contenedor negro semitransparente sobre las imágenes
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Ensombrecer imágenes
            ),
          ),

          // Contenido de la caja
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Evita expandirse demasiado
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
                  const SizedBox(height: 8),
                  // Origen y destino
                  Text(
                    "${AppLocalizations.of(context).translate('origin')}: ${route.places.first.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    "${AppLocalizations.of(context).translate('destiny')}: ${route.places.last.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  // Botón para ver más detalles
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteDetailsScreen.routeName,
                            arguments: route);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('seeMore'),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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

// ClipPath para la parte superior
class TopDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.7, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ClipPath para la parte inferior
class BottomDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
