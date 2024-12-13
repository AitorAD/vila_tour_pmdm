import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class UserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formLogKey = GlobalKey<FormState>();

  late User user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get haveChanges {
    return (user != currentUser);
  }

  void loadUser(User user) {
    this.user = user;
    notifyListeners();
  }

  bool isValidForm() {
    return formLogKey.currentState?.validate() ?? false;
  }
}
