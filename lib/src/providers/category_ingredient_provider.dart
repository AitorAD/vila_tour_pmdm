import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/categoryIngredient.dart';

class CategoryIngredientProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<CategoryIngredient> _categories = [];
  List<CategoryIngredient> _filteredCategories = [];

  List<CategoryIngredient> get categories => _categories;
  List<CategoryIngredient> get filteredCategories => _filteredCategories;

  set categories(List<CategoryIngredient> list) => _categories = list;

  CategoryIngredientProvider() {
    loadCategories();
  }

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  Future<void> loadCategories() async {
    final jsonData = await _getJsonData('categoryIngredients');
    _categories = (json.decode(jsonData) as List)
        .map((item) => CategoryIngredient.fromMap(item))
        .toList();
    _filteredCategories = List.from(_categories); // Inicializar también con todas las categorías
    notifyListeners();
  }

  void filterCategories(String query) {
    print("Filtrando categorías con la query: $query"); // Verificar que la query se recibe
    if (query.isEmpty) {
      _filteredCategories = List.from(_categories); // Si no hay búsqueda, mostrar todas las categorías
    } else {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList(); // Filtrar según la búsqueda
    }
    print("Categorías filtradas: $_filteredCategories"); // Verificar las categorías filtradas
    notifyListeners();
  }
}
