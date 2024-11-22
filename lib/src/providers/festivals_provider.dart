import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';

class FestivalsProvider with ChangeNotifier {
  String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator
  // String _baseUrl = 'http://192.168.x.x:8080'; // En Dispositivo físico
  // String _baseUrl = 'http://localhost:8080'; // En iOS o navegador

  List<Festival> _festivals = [];
  List<Festival> get festivals => _festivals;
  set festivals(List<Festival> list) => _festivals = list;

  FestivalsProvider() {
    loadFestivals();
    print('Festivals Provider Iniciado');
  }

  Future<String> _getJsonData(String endpoint) async {
    var url = Uri.parse('$_baseUrl/$endpoint');
    final response = await http.get(url);
    return response.body;
  }

  void loadFestivals() async {
    final jsonData = await _getJsonData('festivals');
    final festivalList = Festival.fromJsonList(json.decode(jsonData));
    festivals = festivalList;
    notifyListeners();
  }

  /*
  void toggleFavorite(Festival festival) {
    festival.favourite = !festival.favourite;
    notifyListeners();
  }
  */
}