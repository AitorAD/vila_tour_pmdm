import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/festivals.dart';
import 'package:vila_tour_pmdm/src/screens/SplashScreen.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'splash': (BuildContext context) => SplashScreen(),
    'festivals': (BuildContext context) => FestivalsScreen(),
  };
}
