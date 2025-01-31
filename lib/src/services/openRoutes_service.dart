import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class OpenRouteService {
  final String url = baseURL+'/openRoutes'; // Cambia por la URL de tu API

  Future<List<LatLng>> getRoute(List<LatLng> coordinates) async {
    final request = {
      'coordinates': coordinates
          .map((coord) => [coord.longitude, coord.latitude])
          .toList(),
      'profile': 'foot-walking', // Perfil de la ruta
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> coords = data['geometry']['coordinates'];
      return coords
          .map((coord) => LatLng(coord[1], coord[0])) // LatLng espera (lat, lng)
          .toList();
    } else {
      throw Exception('Error al obtener la ruta: ${response.statusCode}');
    }
  }
}