import 'package:flutter/material.dart';

const tealGradientStart = Color(0xFF4FC3F6);
const tealGradientMiddle1 = Color(0xFF44C1CF);
const tealGradientMiddle2 = Color(0xFF25C1CE);
const tealGradientMiddle3 = Color(0xFF17BFC1);
const tealGradientEnd = Color(0xFF01C2A9);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
  ));

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    titleMedium: TextStyle(),
    titleLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  )
);
