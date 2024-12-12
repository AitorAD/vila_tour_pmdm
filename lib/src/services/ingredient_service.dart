import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class IngredientService {
  final String _endpoint = '$baseURL/ingredients';

  Future<List<Ingredient>> fetchIngredients() async {
    try {
      final url = Uri.parse(_endpoint);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Ingredient.fromJsonList(data);
      } else {
        throw HttpException('Failed to load ingredients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching ingredients: $e');
      rethrow;
    }
  }
}