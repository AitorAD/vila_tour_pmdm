import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Ingredient> _ingredients = [];
  List<Ingredient> _filteredIngredients = [];

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get filteredIngredients => _filteredIngredients;

  set ingredients(List<Ingredient> list) => _ingredients = list;

  IngredientsProvider() {
    loadIngredients(); 
  }

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  Future<void> loadIngredients() async {
    final jsonData = await _getJsonData('ingredients');
    _ingredients = Ingredient.fromJsonList(json.decode(jsonData));
    _filteredIngredients = List.from(_ingredients);  // Inicializar también con todos los ingredientes
    notifyListeners();
  }
  
  void filterIngredients(String query) {
  print("Filtrando ingredientes con la query: $query"); // Verificar que la query se recibe
  if (query.isEmpty) {
    _filteredIngredients = List.from(_ingredients); // Si no hay búsqueda, mostrar todos los ingredientes
  } else {
    _filteredIngredients = _ingredients
        .where((ingredient) =>
            ingredient.name.toLowerCase().contains(query.toLowerCase()))
        .toList(); // Filtrar según la búsqueda
  }
  print("Ingredientes filtrados: $_filteredIngredients"); // Verificar los ingredientes filtrados
  notifyListeners();
}

}
