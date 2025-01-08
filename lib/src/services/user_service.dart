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

  Future<User> getBasicInfoUserById(int id) async {
    final url = Uri.parse('$baseURL/users/basic/$id');
    print('Haciendo solicitud a: $url');

    String? token = await UserPreferences.instance.readData('token');
    print('Token obtenido: $token');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print('Respuesta recibida: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('JSON decodificado: $jsonResponse');
        User user = User.fromMap(jsonResponse);
        print('Usuario creado: $user');
        return user;
      } catch (e) {
        print('Error al deserializar el JSON: $e');
        throw Exception('Error al deserializar los datos del usuario');
      }
    } else {
      print('Error en la respuesta del servidor: ${response.statusCode}');
      throw Exception('Error al cargar los datos del usuario');
    }
  }

  Future<bool> modifyUser(User user, User newUser) async {
    final url = Uri.parse('$baseURL/users/${user.id}');

    String? token = await UserPreferences.instance.readData('token');
    print('Token: $token');

    String jsonData = newUser.toJson();
    print('Request body: $jsonData');

    final response = await http.put(
      url,
      body: jsonData,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      currentUser = User.fromJson(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final url = Uri.parse('$baseURL/users/email/exist?email=$email');
      final response = await http.get(url);
      if (response.body.contains("true")) {
        print("Email existe");
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

  // Envía el correo de recuperación
  Future<bool> sendRecoveryEmail(String email) async {
    final url = Uri.parse('$baseURL/auth/recoverymail/email?email=$email');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      return true; // Éxito al enviar el correo
    } else {
      print("Error al enviar el correo. Código HTTP ${response.statusCode}");
      return false; // Fallo al enviar el correo
    }
  }
}
