import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_screen.dart';
import 'package:vila_tour_pmdm/src/screens/SplashScreen.dart';
import 'package:vila_tour_pmdm/src/screens/general_festivals.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'splash': (BuildContext context) => const SplashScreen(),
    'festivals': (BuildContext context) => FestivalsScreen(),
    'general_festivals': (BuildContext context) => GeneralFestivalsScreen(),
    'login': (BuildContext context) => LoginScreen(),
  };
}
