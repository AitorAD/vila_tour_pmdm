import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_screen.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_details_screen.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/recipes_screen.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'festivals': (BuildContext context) => FestivalsScreen(),
    'general_festivals': (BuildContext context) => DetailsFestival(),
    'login': (BuildContext context) => LoginScreen(),
    'registrer_screen': (BuildContext context) => RegistrerScreen(),
    'recipes': (BuildContext context) => RecipesScreen(),
  };
}
