import 'package:flutter/material.dart';

class DefaultDecoration extends StatelessWidget {
  double radius;
  DefaultDecoration({super.key, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: defaultDecoration(radius),
    );
  }

  BoxDecoration defaultDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      gradient: LinearGradient(
        colors: [
          Color(0xFF4FC3F6).withOpacity(0.75),
          Color(0xFF44C1CF).withOpacity(0.75),
          Color(0xFF25C1CE).withOpacity(0.75),
          Color(0xFF17BFC1).withOpacity(0.75),
          Color(0xFF01C2A9).withOpacity(0.75),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );
  }
}