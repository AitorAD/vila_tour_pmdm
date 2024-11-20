import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';

class RecipesProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;
  set recipes(List<Recipe> list) => _recipes = list;

  RecipesProvider() {
    loadRecipes();
  }

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  Future<void> loadRecipes() async {
    final jsonData = await _getJsonData('recipes');
    print('JSON recibido: $jsonData');
    final recipesList = Recipe.fromJsonList(json.decode(jsonData));
    recipes = recipesList;
    notifyListeners();
  }

/*
  void toggleFavorite(Recipe recipe) {
    recipe.favourite = !recipe.favourite;
    notifyListeners();
  }
  */
}