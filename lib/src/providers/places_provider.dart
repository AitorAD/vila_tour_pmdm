import 'package:flutter/foundation.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places => _places;

  void setPlaces(List<Place> places) {
    _places = places;
    notifyListeners(); // Notifica a los listeners que los datos han cambiado
  }
}
