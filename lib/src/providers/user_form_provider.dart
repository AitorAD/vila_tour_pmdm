import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class UserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formLogKey = GlobalKey<FormState>();

  User? user = null;
  bool _isLoading = false;
  bool _haveChanges = false;

  bool get isLoading => _isLoading;
  bool get haveChanges => _haveChanges;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set haveChanges(bool value) {
    if (_haveChanges != value) {
      _haveChanges = value;
      notifyListeners();
    }
  }

  bool isValidForm() {
    print(formLogKey.currentState?.validate());
    return formLogKey.currentState?.validate() ?? false;
  }

  void checkForChanges() {
    print('userForm' + user.toString());
    print('currentUser' + currentUser.toString());
    haveChanges = user != currentUser;
  }
}
