import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';

import '../models/models.dart';

class LoginService extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:8080";

  bool isLoading = true;

  Future<Map<String, dynamic>> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/auth/login');

    final resp = await http.post(
      url,
      body: json.encode({"username": username, "password": password}),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    isLoading = false;
    notifyListeners();

    final Map<String, dynamic> responseData = json.decode(resp.body);

    await UserPreferences.instance.writeData('token', responseData['token']);

    return responseData;
  }

  Future<void> logout(String token) async {
    final url = Uri.parse('$_baseUrl/auth/singout');

    final response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.body}');
    }
  }

  Future<void> register(String username, String email, String password) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/auth/register');

    final resp = await http.post(
      url,
      body: json.encode({"username": username, "email": email, "password": password}),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    this.login(username, password);

    isLoading = false;
    notifyListeners();
  }
}
