import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class LoginService extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:8080";

  bool isLoading = true;

  late User user;

  LoginService(String username, String password) {
    this.login(username, password);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    final resp = await http.post(
      url,
      body: jsonEncode({"username": username, "password": password}),
    );

    if (resp.statusCode == 200) {
      print("resp body: " + resp.body);
      return jsonDecode(resp.body);
    } else {
      throw Exception('Login failed: ${resp.body}');
    }
  }

  Future<void> logout(String token) async {
    final url = Uri.parse('$_baseUrl/auth/singout');

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.body}');
    }
  }
}
