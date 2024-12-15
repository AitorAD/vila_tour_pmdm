import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/services/ingredient_service.dart';

class IngredientsProvider with ChangeNotifier {
  final IngredientService _ingredientService = IngredientService();

  List<Ingredient> _ingredients = [];
  List<Ingredient> _filteredIngredients = [];
  String _currentFilter = '';

  List<Ingredient> get ingredients => _ingredients;
  List<Ingredient> get filteredIngredients => _filteredIngredients;
  String get currentFilter => _currentFilter;

  Future<void> loadIngredients() async {
    try {
      _ingredients = await _ingredientService.fetchIngredients();
      _filteredIngredients = List.from(_ingredients);
      debugPrint(_ingredients.toString());
      notifyListeners();
    } catch (e) {
      print('Error loading ingredients in provider: $e');
    }
  }

  void filterIngredients(String query) {
    _currentFilter = query;
    if (query.isEmpty) {
      _filteredIngredients = List.from(_ingredients);
    } else {
      _filteredIngredients = _ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      debugPrint(_filteredIngredients.toString());
    }
    notifyListeners();
  }

  void removeIngredientFromAvailable(Ingredient ingredient) {
    _ingredients.remove(ingredient);
    _filteredIngredients.remove(ingredient);
    notifyListeners();
  }

  void addIngredientToAvailable(Ingredient ingredient) {
    if (!_ingredients.contains(ingredient)) {
      _ingredients.add(ingredient);
      filterIngredients(currentFilter);
    }
    notifyListeners();
  }
}
