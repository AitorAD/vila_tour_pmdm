import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/services/ingredient_service.dart';

class IngredientsProvider with ChangeNotifier {
  final IngredientService _ingredientService = IngredientService();

  List<Ingredient> _ingredients = [];
  List<Ingredient> _filteredIngredients = [];

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get filteredIngredients => _filteredIngredients;

  Future<void> loadIngredients() async {
    try {
      _ingredients = await _ingredientService.fetchIngredients();
      _filteredIngredients = List.from(_ingredients);
      notifyListeners();
    } catch (e) {
      print('Error loading ingredients in provider: $e');
    }
  }

  void filterIngredients(String query) {
    if (query.isEmpty) {
      _filteredIngredients = List.from(_ingredients);
    } else {
      _filteredIngredients = _ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}