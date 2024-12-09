import 'package:flutter/material.dart';

import 'package:vila_tour_pmdm/src/screens/screens.dart';

import 'package:vila_tour_pmdm/src/screens/festivals_screen.dart';
import 'package:vila_tour_pmdm/src/screens/festivals_details_screen.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/screens/map_screen.dart';
import 'package:vila_tour_pmdm/src/screens/recipes_details_screen.dart';
import 'package:vila_tour_pmdm/src/screens/recipes_screen.dart';
import 'package:vila_tour_pmdm/src/screens/registrer_screen.dart';
import 'package:vila_tour_pmdm/src/screens/upload_screen.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'home': (BuildContext context) => HomePage(),
    'festivals': (BuildContext context) => FestivalsScreen(),
    'general_festivals': (BuildContext context) => DetailsFestival(),
    'general_recipes': (BuildContext context) => RecipeDetails(),
    'login': (BuildContext context) => LoginScreen(),
    'registrer_screen': (BuildContext context) => RegistrerScreen(),
    'recipes': (BuildContext context) => RecipesScreen(),
    'map': (BuildContext context) => MapScreen(),
    'uploadRecipe': (BuildContext context) => UploadRecipe(),
  };
}
