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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Stack(
        children: [
          _BackgroundImage(route: route),
          // Contenido de la caja
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: routeBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  _SeeMore(route: route),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration routeBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.black.withOpacity(0.4),
    );
    /*
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
    */
  }
}

class _SeeMore extends StatelessWidget {
  const _SeeMore({
    super.key,
    required this.route,
  });

  final vilaModels.Route route;

  @override
  Widget build(BuildContext context) {
    return Align(
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
        child: Text(
          AppLocalizations.of(context).translate('seeMore'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  _BackgroundImage({super.key, required this.route});

  final vilaModels.Route route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
          child: ClipPath(
            clipper: TopDiagonalClipper(),
            child: FadeInImage(
              placeholder: const AssetImage('assets/logo.ico'),
              image: (route.places.isNotEmpty &&
                      route.places.first.images.isNotEmpty)
                  ? MemoryImage(
                      decodeImageBase64(route.places.first.images.first.path),
                    )
                  : AssetImage('assets/place_holder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          child: ClipPath(
            clipper: BottomDiagonalClipper(),
            child: FadeInImage(
              placeholder: const AssetImage('assets/logo.ico'),
              image: (route.places.isNotEmpty &&
                      route.places.last.images.isNotEmpty)
                  ? MemoryImage(
                      decodeImageBase64(route.places.last.images.first.path),
                    )
                  : AssetImage('assets/place_holder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

// ClipPath para la parte superior
class TopDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.0, size.height);
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
    path.moveTo(size.width * 1, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
