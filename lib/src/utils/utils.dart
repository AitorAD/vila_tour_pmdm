import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/ui/input_decorations.dart';

// Función que devuelve el estilo de texto con color personalizado
TextStyle textStyleVilaTour({Color color = Colors.white}) {
  return TextStyle(color: color, fontFamily: 'PontanoSans');
}

TextStyle textStyleVilaTourTitle(
    {Color color = Colors.white, double fontSize = 25}) {
  return TextStyle(color: color, fontFamily: 'PontanoSans', fontSize: fontSize);
}

// Función que devuelve la decoración predeterminada con el radio personalizado
BoxDecoration defaultDecoration(double radius, {double opacity = 0.75}) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    gradient: LinearGradient(
      colors: [
        Color(0xFF4FC3F6).withOpacity(opacity),
        Color(0xFF44C1CF).withOpacity(opacity),
        Color(0xFF25C1CE).withOpacity(opacity),
        Color(0xFF17BFC1).withOpacity(opacity),
        Color(0xFF01C2A9).withOpacity(opacity),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );
}

Uint8List decodeImageBase64(String image) {
  try {
    Uint8List bytes = base64Decode(image.split(',')[1]);
    return bytes;
  } catch (e) {
    return base64Decode(image);
  }
}

