import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/SplashScreen.dart';


Map<String, WidgetBuilder> getApplicationRoutes() {
 return <String, WidgetBuilder>{
 '/': (BuildContext context) => SplashScreen(),
 //'festivals': (BuildContext context) => FestivalsScreen(),
 };
}