import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_screen.dart';
import 'package:vila_tour_pmdm/src/screens/SplashScreen.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_details_screen.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'splash': (BuildContext context) => const SplashScreen(),
    'festivals': (BuildContext context) => FestivalsScreen(),
    'general_festivals': (BuildContext context) => DetailsFestival(),
    'login': (BuildContext context) => LoginScreen(),
    'registrer_screen': (BuildContext context) => RegistrerScreen(),
  };
}
