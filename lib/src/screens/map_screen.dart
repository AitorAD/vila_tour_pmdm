import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';

class MapScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Mapa"),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}