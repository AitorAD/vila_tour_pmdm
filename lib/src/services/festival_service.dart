import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/models/models.dart';

class FestivalService {
  final String _baseUrl = 'http://10.0.2.2:8080'; // En Android Emulator

  Future<List<Festival>> fetchFestivals() async {
    try {
      var url = Uri.parse('$_baseUrl/festivals');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Festival.fromJsonList(data);
      } else {
        throw HttpException('Failed to load festivals: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
