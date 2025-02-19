import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class PlaceService {
  Future<List<Place>> getPlaces() async {
    final url = Uri.parse('$baseURL/places');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    List<Place> places = Place.fromJsonList(json.decode(response.body));

    return places;
  }
}
