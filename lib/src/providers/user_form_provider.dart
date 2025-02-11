import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class UserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formUserKey = GlobalKey<FormState>();

  User? user = null;
  bool _isLoading = false;
  bool _haveChanges = false;
  bool _isEditing = false;

  bool get isLoading => _isLoading;
  bool get haveChanges => _haveChanges;
  bool get isEditing => _isEditing;

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

  set isEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formUserKey.currentState?.validate() ?? false;
  }

  void checkForChanges() {
    haveChanges = user != currentUser;
  }

  void resetForm() {
    user = currentUser.copyWith();
    notifyListeners();
  }
}