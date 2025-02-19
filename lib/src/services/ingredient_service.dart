import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class IngredientService {
  final String _endpoint = '$baseURL/ingredients';

  Future<List<Ingredient>> fetchIngredients() async {

    String? token = await UserPreferences.instance.readData('token');
    try {
      final url = Uri.parse(_endpoint);
      final response = await http.get(
        url,
        headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      );

      if (response.statusCode == 200) {

        final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        final List<dynamic> data = jsonResponse;
        return Ingredient.fromJsonList(data);
      } else {
        throw HttpException('Failed to load ingredients: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}