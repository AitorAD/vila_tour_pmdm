import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/screens.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    HomePage.routeName: (BuildContext context) => const HomePage(),
    FestivalsScreen.routeName: (BuildContext context) => const FestivalsScreen(),
    DetailsFestival.routeName: (BuildContext context) => const DetailsFestival(),
    RecipeDetails.routeName: (BuildContext context) => const RecipeDetails(),
    LoginScreen.routeName: (BuildContext context) => const LoginScreen(),
    RegistrerScreen.routeName: (BuildContext context) => const RegistrerScreen(),
    RecipesScreen.routeName: (BuildContext context) => const RecipesScreen(),
    MapScreen.routeName: (BuildContext context) => MapScreen(),
    UploadRecipe.routeName: (BuildContext context) => UploadRecipe(),
    UserScreen.routeName: (BuildContext context) => const UserScreen(),
    PasswordRecovery.routeName: (BuildContext context) => const PasswordRecovery(),
    PlacesScreen.routeName: (BuildContext context) => const PlacesScreen(),
    PlacesDetails.routeName: (BuildContext context) => const PlacesDetails(),
    AddReviewScreen.routeName: (BuildContext context) => const AddReviewScreen(),
    LanguagesScreen.routeName: (BuildContext context) => const LanguagesScreen(),
    RoutesScreen.routeName: (BuildContext context) => const RoutesScreen(),
    RouteDetailsScreen.routeName: (BuildContext context) => const RouteDetailsScreen(),
  };
}
