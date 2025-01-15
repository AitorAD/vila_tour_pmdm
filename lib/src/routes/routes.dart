import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/map_screen2.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    HomePage.routeName: (BuildContext context) => HomePage(),
    FestivalsScreen.routeName: (BuildContext context) => FestivalsScreen(),
    DetailsFestival.routeName: (BuildContext context) => DetailsFestival(),
    RecipeDetails.routeName: (BuildContext context) => RecipeDetails(),
    LoginScreen.routeName: (BuildContext context) => LoginScreen(),
    RegistrerScreen.routeName: (BuildContext context) => RegistrerScreen(),
    RecipesScreen.routeName: (BuildContext context) => RecipesScreen(),
    MapScreen.routeName: (BuildContext context) => MapScreen2(),
    UploadRecipe.routeName: (BuildContext context) => UploadRecipe(),
    UserScreen.routeName: (BuildContext context) => UserScreen(),
    PasswordRecovery.routeName: (BuildContext context) => PasswordRecovery(),
    PlacesScreen.routeName: (BuildContext context) => PlacesScreen(),
    PlacesDetails.routeName: (BuildContext context) => PlacesDetails(),
    AddReviewScreen.routeName: (BuildContext context) => AddReviewScreen(),
  };
}
