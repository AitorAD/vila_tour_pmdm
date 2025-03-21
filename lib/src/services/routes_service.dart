import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class RouteService {
  Future<List<Route>> getRoutes() async {
    final url = Uri.parse('$baseURL/routes');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
    
    List<Route> routes =
        Route.fromJsonList(jsonResponse);

    return routes;
  }
}
