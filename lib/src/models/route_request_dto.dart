import 'dart:convert';
import 'package:latlong2/latlong.dart';

class RouteRequestDTO {
  final List<List<double>> coordinates;
  final String profile;

  RouteRequestDTO({
    required this.coordinates,
    required this.profile,
  });

  // Convierte el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
      'profile': profile,
    };
  }
}

class RouteResponse {
  final List<LatLng> coordinates;

  RouteResponse({required this.coordinates});

  // Convierte JSON a un objeto RouteResponse
  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> coords = json['geometry']['coordinates'];
    final List<LatLng> points = coords
        .map((coord) => LatLng(coord[1], coord[0])) // LatLng espera (lat, lng)
        .toList();
    return RouteResponse(coordinates: points);
  }
}