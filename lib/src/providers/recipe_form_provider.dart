import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class RecipeFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formRecipeKey = GlobalKey<FormState>();

  Recipe? _recipe = null;

  Recipe get recipe => _recipe!;

  set recipe(Recipe? recipe) {
    _recipe = recipe;
    notifyListeners();
  }

  void setRecipeParams(String? name, String? description) {
    if (name != null) _recipe!.name = name;
    if (description != null) _recipe!.description = description;

    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formRecipeKey.currentState?.validate());
    return formRecipeKey.currentState?.validate() ?? false;
  }
}
