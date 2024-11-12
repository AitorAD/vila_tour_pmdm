import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'festivals': (BuildContext context) => FestivalsScreen(),
    'general_festivals': (BuildContext context) => DetailsFestival(),
    'general_recipes': (BuildContext context) => RecipeDetails(),
    'login': (BuildContext context) => LoginScreen(),
    'registrer_screen': (BuildContext context) => RegistrerScreen(),
    'recipes': (BuildContext context) => RecipesScreen(),
    'map': (BuildContext context) => MapScreen(),
  };
}
