import 'package:flutter/material.dart';

// Función que devuelve el estilo de texto con color personalizado
TextStyle textStyleVilaTour({Color color = Colors.white}) {
  return TextStyle(color: color, fontFamily: 'PontanoSans');
}

TextStyle textStyleVilaTourTitle({Color color = Colors.white, double fontSize = 25}) {
  return TextStyle(color: color, fontFamily: 'PontanoSans', fontSize: fontSize);
}

// Función que devuelve la decoración predeterminada con el radio personalizado
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


