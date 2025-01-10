import 'package:flutter/material.dart';

class ReviewFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formRegisterKey = new GlobalKey<FormState>();

  String comment = '';
  int rating = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formRegisterKey.currentState?.validate());
    return formRegisterKey.currentState?.validate() ?? false;
  }
}
