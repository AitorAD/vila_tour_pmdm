import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

import '../models/models.dart';

class UserService extends ChangeNotifier {
  bool isLoading = true;

  Future<User> getCurrentUser(int id) async {
    final url = Uri.parse('$baseURL/users/$id');

    String? token = await UserPreferences.instance.readData('token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    User currentUser = User.fromJson(response.body);
    return currentUser;
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final url = Uri.parse('$baseURL/users/email/exist?email=$email');
      final response = await http.get(url);

      if (response.body.contains("true")) {
        return true;
      } else {
        print('Error: Código HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al verificar el correo: $e');
      return false;
    }
  }
}
