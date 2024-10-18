import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {'festivals_traditions_screen': (_) => FestivalsAndTraditionsScreen()},
      initialRoute: 'festivals_traditions_screen',
    );
  }
}
