import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/screens/login_screen.dart';
import 'package:vila_tour_pmdm/src/services/user_service.dart';
import 'package:vila_tour_pmdm/src/utils/result.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class LoginService extends ChangeNotifier {
  bool isLoading = true;

  Future<Result> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseURL/auth/login');

      final response = await http.post(
        url,
        body: json.encode({"username": username, "password": password}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        
        // Guardar el token de acceso
        final String token = responseData['token'];
        final int tokenDurationMs = responseData['expiration'];
        await UserPreferences.instance.saveToken(token, tokenDurationMs);

        int id = responseData['id'];
        currentUser = await UserService().getCurrentUser(id);
        return Result.success;
      } else if (response.statusCode == 401) {
        return Result.invalidCredentials;
      } else if (response.statusCode >= 500) {
        return Result.serverError;
      } else {
        return Result.unexpectedError;
      }
    } catch (e) {
      return Result.noConnection;
    }
  }

  Future<String?> getToken() async {
    return UserPreferences.instance.token;
  }

  Future<int?> getTokenDurationMs() async {
    return UserPreferences.instance.tokenDurationMs;
  }

  Future<void> logout(BuildContext context) async {
    final url = Uri.parse('$baseURL/auth/singout');

    final response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (response.statusCode == 200) {
      await UserPreferences.instance.deleteToken(); // Eliminar token guardado
      print("Sesión cerrada y token eliminado.");
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      throw Exception('Error al cerrar sesión: ${response.body}');
    }
  }

  Future<Result> register(String username, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse('$baseURL/auth/register');

      final response = await http.post(
        url,
        body: json.encode(
            {"username": username, "email": email, "password": password}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 201) {
        // Registro exitoso, intentar iniciar sesión automáticamente
        final loginResult = await this.login(username, password);
        return loginResult == Result.success ? Result.success : loginResult;
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        if (responseData['error'] == 'email_already_in_use') {
          return Result.invalidCredentials;
        } else {
          return Result.invalidData;
        }
      } else if (response.statusCode >= 500) {
        return Result.serverError;
      } else {
        return Result.unexpectedError;
      }
    } on SocketException {
      return Result.noConnection;
    } catch (e) {
      return Result.unexpectedError;
    }
  }
}