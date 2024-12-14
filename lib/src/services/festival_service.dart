import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class FestivalService {
  Future<List<Festival>> getFestivals() async {
    final url = Uri.parse('$baseURL/festivals');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print('Response Body: ' + response.body);

    // Verificamos el tipo de respuesta, si es una lista directa
    List<dynamic> responseData = json.decode(response.body);

    print('Response Data: ' + responseData.toString());

    // Convertimos la lista de festivales
    List<Festival> festivals = [];
    for (var element in responseData) {
      festivals.add(Festival.fromMap(element));
    }

    print('Festivals: ' + festivals.toString());

    // Imprimimos los festivales
    for (Festival festival in festivals) {
      print('Festival: ' + festival.toString());
    }

    return festivals;
  }
}
