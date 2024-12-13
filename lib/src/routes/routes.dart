import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/password_recovery.dart';

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
import 'package:vila_tour_pmdm/src/screens/user_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    HomePage.routeName: (BuildContext context) => HomePage(),
    FestivalsScreen.routeName: (BuildContext context) => FestivalsScreen(),
    DetailsFestival.routeName: (BuildContext context) => DetailsFestival(),
    RecipeDetails.routeName: (BuildContext context) => RecipeDetails(),
    LoginScreen.routeName: (BuildContext context) => LoginScreen(),
    RegistrerScreen.routeName: (BuildContext context) => RegistrerScreen(),
    RecipesScreen.routeName: (BuildContext context) => RecipesScreen(),
    MapScreen.routeName: (BuildContext context) => MapScreen(),
    UploadRecipe.routeName: (BuildContext context) => UploadRecipe(),
    UserScreen.routeName: (BuildContext context) => UserScreen(),
    PasswordRecovery.routeName: (BuildContext context) => PasswordRecovery(),
  };
}
