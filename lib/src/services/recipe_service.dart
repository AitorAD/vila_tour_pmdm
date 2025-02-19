import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class RecipeService {
  final String _baseUrl = baseURL;

  /// Obtiene la lista de recetas desde el servidor
  Future<List<Recipe>> getRecipes() async {
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
        final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        final List<dynamic> responseData = jsonResponse;
        return responseData.map((json) => Recipe.fromMap(json)).toList();
      } else {
        throw HttpException('Failed to fetch recipes: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Crea una nueva receta en el servidor
  Future<Recipe> createRecipe(Recipe recipe) async {
    final String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final url = Uri.parse('$_baseUrl/recipes');
      final String jsonBody = jsonEncode(recipe.toMap());

      print('RECETA JSON BODY: ' + jsonBody);

      final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        final Map<String, dynamic> responseData = jsonResponse;
        return Recipe.fromMap(responseData);
      } else {
        throw HttpException(
            'Failed to create recipe: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Obtiene las recetas de un usuario
  Future<List<Recipe>> getUserRecipes(int idUser) async {
    final String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      final url = Uri.parse('$_baseUrl/recipes/search/creatorId?creatorId=$idUser');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
        final List<dynamic> responseData = jsonResponse;
        return responseData.map((json) => Recipe.fromMap(json)).toList();
      } else {
        throw HttpException('Failed to fetch user recipes: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
