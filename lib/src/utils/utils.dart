import 'package:flutter/material.dart';

TextStyle textStyleVilaTour =
    const TextStyle(color: Colors.white, fontFamily: 'PontanoSans');
TextStyle textStyleVilaTourTitle = const TextStyle(
    color: Colors.white, fontFamily: 'PontanoSans', fontSize: 25);

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
