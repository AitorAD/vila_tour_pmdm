import 'package:flutter/material.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class FestivalsProvider with ChangeNotifier {
  List<Festival> _festivals = [];

  List<Festival> get festivals => _festivals;

  FestivalsProvider() {
    loadFestivals(); 
  }

  Future<void> loadFestivals() async {
    final festivalData = await _getFestivals();
    _festivals = festivalData.map((data) => Festival.fromMap(data)).toList();
    notifyListeners();
  }

  void toggleFavorite(Festival festival) {
    festival.favourite = !festival.favourite;
    notifyListeners();
  }
}


Future<List<Map<String, dynamic>>> _getFestivals() async {
  // Provisional hasta cargar la API
  return [
    {
      "idIngredient": 1,
      "name": "Pollo",
      "category": "DAIRY",
    },
  ];
}
