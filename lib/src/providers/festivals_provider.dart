import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';

class FestivalsProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Festival> _festivals = [];
  List<Festival> _filteredFestivals = [];
  String _currentFilter = '';

  List<Festival> get festivals => _festivals;
  List<Festival> get filteredFestivals => _filteredFestivals;
  String get currentFilter => _currentFilter;

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  Future<void> loadFestivals() async {
    try {
      final jsonData = await _getJsonData('festivals');
      final festivalList = Festival.fromJsonList(json.decode(jsonData));
      _festivals = festivalList;
      _filteredFestivals = List.from(_festivals);
      notifyListeners();
    } catch (e) {
      print('Error loading festivals in provider: $e');
    }
  }

  void filterFestivals(String query) {
    _currentFilter = query;
    if (query.isEmpty) {
      _filteredFestivals = List.from(_festivals);
    } else {
      _filteredFestivals = _festivals
          .where((festival) =>
              festival.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addFestivalToAvailable(Festival festival) {
    if (!_festivals.contains(festival)) {
      _festivals.add(festival);
      filterFestivals(_currentFilter);
    }
    notifyListeners();
  }

  void removeFestivalFromAvailable(Festival festival) {
    _festivals.remove(festival);
    _filteredFestivals.remove(festival);
    notifyListeners();
  }
}
