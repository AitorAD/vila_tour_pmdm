import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vila_tour_pmdm/src/prefs/user_preferences.dart';
import 'package:vila_tour_pmdm/src/utils/result.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

import '../models/models.dart';

class UserService extends ChangeNotifier {
  bool isLoading = true;

  Future<User?> getCurrentUser() async {
    try {
      final url = Uri.parse('$baseURL/users/${currentAccount.id}');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${UserPreferences.instance.readData('token')}',
        },
      );

      if (response.statusCode == 200) {
        User currentUser = User.fromJson(response.body);
        print(currentUser);
        return currentUser;
      }
    } catch (e) {
      return null;
    }
  }
}
