import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';

class RecipesProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _currentFilter = '';

  List<Recipe> get recipes => _recipes;
  List<Recipe> get filteredRecipes => _filteredRecipes;
  String get currentFilter => _currentFilter;

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    return response.body;
  }

  Future<void> loadRecipes() async {
    try {
      final jsonData = await _getJsonData('recipes');
      final recipesList = Recipe.fromJsonList(json.decode(jsonData));
      _recipes = recipesList;
      _filteredRecipes = List.from(_recipes);
      notifyListeners();
    } catch (e) {
      print('Error loading recipes in provider: $e');
    }
  }

  void filterRecipes(String query) {
    _currentFilter = query;
    if (query.isEmpty) {
      _filteredRecipes = List.from(_recipes);
    } else {
      _filteredRecipes = _recipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addRecipeToAvailable(Recipe recipe) {
    if (!_recipes.contains(recipe)) {
      _recipes.add(recipe);
      filterRecipes(_currentFilter);
    }
    notifyListeners();
  }

  void removeRecipeFromAvailable(Recipe recipe) {
    _recipes.remove(recipe);
    _filteredRecipes.remove(recipe);
    notifyListeners();
  }

  static String getBase64FormateFile(String path) {
    File file = File(path);
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
