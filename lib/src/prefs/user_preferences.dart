import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences {
  UserPreferences._internal();

  static final UserPreferences _instance = UserPreferences._internal();

  static UserPreferences get instance => _instance;

  final FlutterSecureStorage _prefs = FlutterSecureStorage();

  String? _token;
  int? _tokenDurationMs;

  String? get token => _token;
  int? get tokenDurationMs => _tokenDurationMs;

  Future<void> initPrefs() async {
    try {
      _token = await _prefs.read(key: 'token');
      String? tokenDurationMsString = await _prefs.read(key: 'expiration');
      if (tokenDurationMsString != null) {
        _tokenDurationMs = int.tryParse(tokenDurationMsString);
      }
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

  Future<void> saveToken(String token, int tokenDurationMs) async {
    await _prefs.write(key: 'token', value: token);
    await _prefs.write(key: 'expiration', value: tokenDurationMs.toString());
    _token = token;
    _tokenDurationMs = tokenDurationMs;
  }

  Future<void> deleteToken() async {
    await _prefs.delete(key: 'token');
    await _prefs.delete(key: 'expiration');
    _token = null;
    _tokenDurationMs = null;
  }

  bool isTokenValid() {
    if (_token == null || _tokenDurationMs == null) {
      return false;
    }
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(_tokenDurationMs!);
    return DateTime.now().isBefore(expiryDate);
  }

  Duration getTokenRemainingDuration() {
    if (_tokenDurationMs == null) {
      return Duration.zero;
    }
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(_tokenDurationMs!);
    return expiryDate.difference(DateTime.now());
  }
}