import 'package:flutter/material.dart';

const tealGradientStart = Color(0xFF4FC3F6);
const tealGradientMiddle1 = Color(0xFF44C1CF);
const tealGradientMiddle2 = Color(0xFF25C1CE);
const tealGradientMiddle3 = Color(0xFF17BFC1);
const tealGradientEnd = Color(0xFF01C2A9);

ThemeData lightMode = ThemeData(brightness: Brightness.light);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: tealGradientMiddle3,
    primaryContainer: tealGradientEnd,
    secondary: tealGradientMiddle1,
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white70,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    color: Color(0xFF1E1E1E), // Fondo oscuro para el modo oscuro
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: tealGradientEnd,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(tealGradientMiddle2),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    ),
  ),
);
