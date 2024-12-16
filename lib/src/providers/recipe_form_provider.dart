import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class RecipeFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formLogKey = GlobalKey<FormState>();

  Recipe? recipe = null;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formLogKey.currentState?.validate());
    return formLogKey.currentState?.validate() ?? false;
  }
}
