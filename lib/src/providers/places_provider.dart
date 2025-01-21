import 'package:flutter/foundation.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class PlacesProvider extends ChangeNotifier {
  List<Place> _places = [];
  List<String> _selectedCategories = [];

  List<Place> get places => _places;

  List<String> get selectedCategories => _selectedCategories;

  void setPlaces(List<Place> places) {
    _places = places;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  List<Place> filterPlaces(String query) {
    return _places.where((place) {
      final matchesQuery =
          place.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          _selectedCategories.contains(place.categoryPlace.name);
      return matchesQuery && matchesCategory;
    }).toList();
  }
}
