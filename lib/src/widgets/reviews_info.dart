import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vila_tour_pmdm/src/languages/app_localizations.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/paint_stars.dart';

class ReviewsInfo extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsInfo({
    super.key,
    required this.reviews,
  });

  Future<List<Map<String, dynamic>>> _loadReviewsWithUsers(
      BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);

    // Cargamos la información de los usuarios para cada review
    final reviewsWithUsers = await Future.wait(
      reviews.map((review) async {
        final user = await userService.getBasicInfoUserById(review.id.userId);
        return {
          'review': review,
          'user': user,
        };
      }).toList(),
    );

    return reviewsWithUsers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadReviewsWithUsers(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostrar un único indicador de carga
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Manejar errores en la carga
          return Center(
              child: Text(
                  AppLocalizations.of(context).translate('loadReviewsError')));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Manejar el caso de datos vacíos
          return Center(
              child: Text(AppLocalizations.of(context).translate('noReviews')));
        } else {
          // Mostrar las reseñas con los usuarios
          final reviewsWithUsers = snapshot.data!;
          return Column(
            children: [
              _StarRatingDistribution(reviews: reviews),
              const SizedBox(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: reviewsWithUsers.length +
                      1, // Añadir un elemento extra para el SizedBox
                  itemBuilder: (context, index) {
                    if (index == reviewsWithUsers.length) {
                      return const SizedBox(height: 65); // Espacio adicional al final
                    }
                    final reviewWithUser = reviewsWithUsers[index];
                    final review = reviewWithUser['review'] as Review;
                    final user = reviewWithUser['user'] as User;

                    return ReviewBox(review: review, user: user);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class ReviewBox extends StatelessWidget {
  final Review review;
  final User user;

  const ReviewBox({
    super.key,
    required this.review,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: getImage(user.profilePicture),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: textStyleVilaTourTitle(
                                color: Colors.black, fontSize: 15),
                          ),
                          Row(
                            children: [
                              PaintStars(
                                rating: review.rating.toDouble(),
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(review.postDate),
                                style: textStyleVilaTourTitle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                review.comment.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(review.comment, textAlign: TextAlign.start),
                      )
                    : Container(),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _StarRatingDistribution extends StatelessWidget {
  final List<Review> reviews;

  const _StarRatingDistribution({
    super.key,
    required this.reviews,
  });

  Map<int, double> _calculateRatingsPercentage() {
    // Inicializamos un mapa para contar las estrellas
    Map<int, int> starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    int totalReviews = reviews.length;

    // Contamos las calificaciones
    for (var review in reviews) {
      starCounts[review.rating] = (starCounts[review.rating] ?? 0) + 1;
    }

    // Calculamos los porcentajes
    return starCounts
        .map((stars, count) => MapEntry(stars, count / totalReviews));
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos los porcentajes dinámicamente
    final ratingsPercentage = _calculateRatingsPercentage();
    final double averageRating = reviews.isNotEmpty
        ? reviews.map((review) => review.rating).reduce((a, b) => a + b) /
            reviews.length
        : 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna izquierda: barras de progreso
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ratingsPercentage.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: entry.value,
                          backgroundColor: Colors.grey[300],
                          color: Colors.amber,
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${entry.key}'),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Columna derecha: puntuación promedio, estrellas y comentarios
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    PaintStars(rating: averageRating, color: Colors.amber),
                    // TODO: Mostrar el numero de reseñas.
                    //Este numero marca la cantidad de gente que ha valorado el artículo

                    /*
                    Text(
                      '(${reviews.length})',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    */
                  ],
                ),
                Text(
                  '${reviews.where((review) => review.comment.isNotEmpty).length} comentarios',
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
