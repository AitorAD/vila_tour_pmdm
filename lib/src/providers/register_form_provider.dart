import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formRegisterKey = new GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print('$username - $email - $password');
    print(formRegisterKey.currentState?.validate());
    return formRegisterKey.currentState?.validate() ?? false;
  }

  void changePassword(String newPassword) {
    this.password = newPassword;
    notifyListeners();
  }

  bool validateRepeatedPassword(String repeatedPassword) {
    bool repeated = false;
    (this.password == repeatedPassword) ? repeated = true : repeated = false;
    return repeated;
  }
}
