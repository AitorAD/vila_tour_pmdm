import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences {
  UserPreferences._internal();

  static final UserPreferences _instance = UserPreferences._internal();

  static UserPreferences get instance => _instance;

  final FlutterSecureStorage _prefs = FlutterSecureStorage();

  String? _token;

  Future<void> initPrefs() async {
    try {
      _token = await _prefs.read(key: 'token') ?? '';
      print("Token leido correctamente: $_token");
    } catch (e) {
      print("Error leyendo el token: $e");
    }
  }

  Future<void> writeData(String key, String value) async {
    await _prefs.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _prefs.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _prefs.delete(key: key);
  }

  Future<void> deleteAllData() async {
    await _prefs.deleteAll();
  }
}
