import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/screens/SplashScreen.dart';
import 'package:vila_tour_pmdm/src/screens/home.dart';
import 'package:vila_tour_pmdm/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
    title: 'VILATOUR',
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''),
      Locale('es', 'ES')
    ],
    routes: getApplicationRoutes(),
    onGenerateRoute: (RouteSettings settings) {
      print('Ruta llamada: ${settings.name}');

      return MaterialPageRoute(
        builder: (BuildContext context) => HomePage()
      );
    },
  );
 }
}
