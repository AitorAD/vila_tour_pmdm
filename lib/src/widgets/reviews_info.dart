import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/paint_stars.dart';

class ReviewsInfo extends StatelessWidget {

  const ReviewsInfo({
    super.key,
    required this.ratings,
  });

  final List<Map<String, dynamic>> ratings;

  @override
  Widget build(BuildContext context) {
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
              children: ratings.map((rating) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: rating['percentage'],
                          backgroundColor: Colors.grey[300],
                          color: Colors.amber,
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Columna derecha: puntuación, estrellas y comentarios
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '4.8',
                  style: TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
                PaintStars(rating: 4.8, color: Colors.amber),
                Text(
                  '100000.037 comentarios',
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
    final List<Map<String, dynamic>> ratings = [
      {'stars': 5, 'percentage': 0.76},
      {'stars': 4, 'percentage': 0.13},
      {'stars': 3, 'percentage': 0.04},
      {'stars': 2, 'percentage': 0.04},
      {'stars': 1, 'percentage': 0.04},
    ];
*/