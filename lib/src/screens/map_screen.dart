import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vila_tour_pmdm/src/widgets/widgets.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_app_bar.dart';
import 'package:vila_tour_pmdm/src/widgets/custom_navigation_bar.dart';


class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Mapa"),
      body: _MapBody(),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _MapBody extends StatelessWidget {
  const _MapBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return FlutterMap(
      options: MapOptions(
        initialCenter:
            LatLng(38.5227, -0.1981),
        initialZoom: 13.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                  38.5227, -0.1981),
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],

    );
  }
}
