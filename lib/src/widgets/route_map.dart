import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteMap extends StatelessWidget {
  final List<LatLng> routePoints;

  const RouteMap({Key? key, required this.routePoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: routePoints.isNotEmpty ? routePoints.first : LatLng(38.5227, -0.1981),
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints,
              color: Colors.blue,
              strokeWidth: 4.0,
            ),
          ],
        ),
      ],
    );
  }
}
