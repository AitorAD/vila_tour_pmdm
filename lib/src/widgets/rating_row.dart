import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/utils/utils.dart';
import 'package:vila_tour_pmdm/src/widgets/paint_stars.dart';

class RatingRow extends StatelessWidget {
  final double averageScore;
  final int reviewCount;

  const RatingRow({
    Key? key,
    required this.averageScore,
    required this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: defaultDecoration(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            averageScore.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'PontanoSans',
            ),
          ),
          const SizedBox(width: 4),
          PaintStars(rating: averageScore, color: Colors.yellow),
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}