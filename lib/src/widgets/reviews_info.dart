import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StarRatingDistribution(reviews: reviews),
        Expanded(
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewBox(review: reviews[index]);
            },
          ),
        ),
      ],
    );
  }
}

class ReviewBox extends StatelessWidget {
  final Review review;

  const ReviewBox({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    return FutureBuilder<User>(
      future: userService.getBasicInfoUserById(review.id.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras esperas el Future
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Muestra un mensaje de error si el Future falla
          return Center(child: Text('Error al cargar el usuario'));
        } else if (!snapshot.hasData) {
          // Maneja el caso donde no hay datos
          return Center(child: Text('Usuario no encontrado'));
        } else {
          // Si todo está bien, usa el resultado
          final user = snapshot.data!;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: getImage(user.profilePicture),
                      ),
                      SizedBox(width: 12),
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
                              SizedBox(width: 8),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(review.comment),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _StarRatingDistribution extends StatelessWidget {
  final List<Review> reviews;

  _StarRatingDistribution({
    super.key,
    required this.reviews,
  });

  Map<int, double> _calculateRatingsPercentage() {
    // Inicializamos un mapa para contar las estrellas
    Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
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
                      Icon(Icons.star, color: Colors.amber, size: 20),
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
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                PaintStars(rating: averageRating, color: Colors.amber),
                Text(
                  '${reviews.length} comentarios',
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
