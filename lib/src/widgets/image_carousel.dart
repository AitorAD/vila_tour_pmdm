import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String route = LoginScreen.routeName;
        if (article is Festival) route = DetailsFestival.routeName;
        if (article is Place) route = PlacesDetails.routeName;
        if (article is Recipe) route = RecipeDetails.routeName;
        Navigator.pushNamed(
          context,
          route,
          arguments: article,
        );
      },
      child: Hero(
        tag: article.id,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: FadeInImage(
            placeholder: const AssetImage('assets/logo.ico'),
            image: article.images.isEmpty
                ? const AssetImage('assets/logo.ico')
                : MemoryImage(
                    decodeImageBase64(article.images.first.path),
                  ),
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            placeholderFit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  static CarouselOptions carouselOptions() {
    return CarouselOptions(
      height: 300,
      autoPlay: true, // Reproducción automática
      autoPlayInterval: const Duration(seconds: 3), // Intervalo
      enlargeCenterPage: true, // Resalta la diapositiva central
      viewportFraction: 0.9, // Ocupa el 90% del ancho de la pantalla
    );
  }
}
