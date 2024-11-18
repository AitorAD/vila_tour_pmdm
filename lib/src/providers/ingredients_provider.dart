import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  List<Ingredient> _ingredients = [];
  List<Ingredient> _filteredIngredients = [];

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get filteredIngredients => _filteredIngredients;

  IngredientsProvider() {
    loadIngredients(); 
  }

  Future<void> loadIngredients() async {
    final ingredientData = await _getIngredients();
    _ingredients = ingredientData.map((data) => Ingredient.fromMap(data)).toList();
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

Future<List<Map<String, dynamic>>> _getIngredients() async {
  // Provisional hasta conectar con la API
  return [
    {
      "idIngredient": 1,
      "name": "Pollo",
      "category": "DAIRY",
    },
    {
      "idIngredient": 2,
      "name": "Arroz",
      "category": "CEREALS",
    },
    {
      "idIngredient": 3,
      "name": "Aceite",
      "category": "OILS_AND_FATS",
    },
    {
      "idIngredient": 4,
      "name": "Sal",
      "category": "SPICES_AND_HERBS",
    },
  ];
}
