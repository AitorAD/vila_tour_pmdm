import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';

class RecipeService {
  final String _baseUrl = 'http://10.0.2.2:8080';

  Future<List<Recipe>> fetchRecipes() async {
    String? token = await UserPreferences.instance.readData('token');
    if (token == null) {
      throw Exception('Token is null');
    }

    try {
      var url = Uri.parse('$_baseUrl/recipes');
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Recipe.fromJsonList(data);
      } else {
        throw HttpException('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
  String? token = await UserPreferences.instance.readData('token');
  if (token == null) {
    throw Exception('Token is null');
  }

  try {
    var url = Uri.parse('$_baseUrl/recipes');
    String jsonBody = jsonEncode(recipe);
    print(jsonBody);

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw HttpException('Failed to create recipe: ${response.statusCode}');
    }
  } catch (e) {
    rethrow;
  }
}

}
