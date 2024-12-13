import 'package:flutter/material.dart';

class PaintStars extends StatelessWidget {
  final double rating;
  final Color color;
  const PaintStars({
    super.key,
    required this.rating,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: color);
        } else if (rating - index >= 0.5) {
          // Estrella a la mitad
          return Icon(Icons.star_half, color: color);
        } else {
          // Estrellas vacías
          return Icon(Icons.star_border, color: color);
        }
      }),
    );
  }
}
