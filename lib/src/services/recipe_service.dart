import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';

class RecipeService {
  final String _baseUrl = 'http://10.0.2.2:8080';

  /// Obtiene la lista de recetas desde el servidor
  Future<List<Recipe>> fetchRecipes() async {
    final String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final url = Uri.parse('$_baseUrl/recipes');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => Recipe.fromMap(json)).toList();
      } else {
        throw HttpException('Failed to fetch recipes: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Crea una nueva receta en el servidor
  Future<Recipe> createRecipe(Recipe recipe) async {
    final String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final url = Uri.parse('$_baseUrl/recipes');
      final String jsonBody = jsonEncode(recipe.toMap());
      print('Request body: $jsonBody');

      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Recipe.fromMap(responseData);
      } else {
        throw HttpException(
            'Failed to create recipe: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
