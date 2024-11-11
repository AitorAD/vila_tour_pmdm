import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/ingredient.dart';

class IngredientsProvider with ChangeNotifier {
  List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  IngredientsProvider() {
    loadIngredients(); 
  }

  Future<void> loadIngredients() async {
    final ingredientData = await _getIngredients();
    _ingredients = ingredientData.map((data) => Ingredient.fromMap(data)).toList();
    notifyListeners();
  }

}

Future<List<Map<String, dynamic>>> _getIngredients() async {
  //Provisional hasta conectar con la API
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