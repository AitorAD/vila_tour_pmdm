import 'package:flutter/material.dart';

class PaintStars extends StatelessWidget {
  final double rating;
  const PaintStars({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.yellow);
        } else if (rating - index >= 0.5) {
          // Estrella a la mitad
          return Icon(Icons.star_half, color: Colors.yellow);
        } else {
          // Estrellas vacías
          return Icon(Icons.star_border, color: Colors.yellow);
        }
      }),
    );
  }
}
