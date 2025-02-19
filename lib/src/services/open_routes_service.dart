import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';
import 'package:vila_tour_pmdm/src/models/models.dart' as vilaModels;

class OpenRouteService {
  Future<vilaModels.ResponseRouteAPI> getOpenRouteWithPositionByRoute(
      vilaModels.Route route, String profile, Position? currentPosition) async {
    final url = Uri.parse('$baseURL/openRoutes');

    String? token = await UserPreferences.instance.readData('token');

    List<List<double>>? coordinatesList = [];

    if (currentPosition != null) {
      coordinatesList
          .add([currentPosition.longitude, currentPosition.latitude]);
    }
    for (var place in route.places) {
      coordinatesList
          .add([place.coordinate.longitude, place.coordinate.latitude]);
    }

    vilaModels.RouteRequestDTO routeRequestDTO = vilaModels.RouteRequestDTO(
      coordinates: coordinatesList,
      profile: profile,
    );

    print('ROUTE REQUEST DTO: ' + routeRequestDTO.toJson());

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: routeRequestDTO.toJson(),
    );

    vilaModels.ResponseRouteAPI responseRouteApi =
        vilaModels.ResponseRouteAPI.fromJson(response.body);

    return responseRouteApi;
  }
}
