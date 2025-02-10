import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vila_tour_pmdm/src/models/user.dart';
import 'package:vila_tour_pmdm/src/services/config.dart';

class UserPreferences {
  UserPreferences._internal();

  static final UserPreferences _instance = UserPreferences._internal();

  static UserPreferences get instance => _instance;

  final FlutterSecureStorage _prefs = const FlutterSecureStorage();
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
      currentUser = await getUser() ?? currentUser;

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

    // Guardar la fecha de expiración
    final expiryDate = DateTime.now().add(Duration(milliseconds: tokenDurationMs));
    await _prefs.write(key: 'expirationDate', value: expiryDate.toIso8601String());

    _token = token;
    _tokenDurationMs = tokenDurationMs;
  }

  Future<DateTime?> getExpirationDate() async {
    final expiryDateString = await _prefs.read(key: 'expirationDate');
    if (expiryDateString != null) {
      return DateTime.parse(expiryDateString);
    }
    return null;
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

  Future<void> saveLanguage(String languageCode) async {
    await _prefs.write(key: 'language', value: languageCode);
    print("Idioma guardado correctamente: $languageCode");
  }

  Future<String?> getLanguage() async {
    print("Idioma leido correctamente: ${await _prefs.read(key: 'language')}");
    return await _prefs.read(key: 'language') ?? 'en';
  }

  Future<void> saveUser(User user) async {
    await _prefs.write(key: 'userId', value: user.id.toString());
    await _prefs.write(key: 'username', value: user.username);
    await _prefs.write(key: 'email', value: user.email);
    await _prefs.write(key: 'role', value: user.role);
    await _prefs.write(key: 'name', value: user.name ?? '');
    await _prefs.write(key: 'surname', value: user.surname ?? '');
    await _prefs.write(key: 'profilePicture', value: user.profilePicture ?? '');
  }

  Future<User?> getUser() async {
    try {
      final id = await _prefs.read(key: 'userId');
      final username = await _prefs.read(key: 'username');
      final email = await _prefs.read(key: 'email');
      final role = await _prefs.read(key: 'role');
      final name = await _prefs.read(key: 'name');
      final surname = await _prefs.read(key: 'surname');
      final profilePicture = await _prefs.read(key: 'profilePicture');

      if (id != null && username != null && email != null && role != null) {
        return User(
          id: int.parse(id),
          username: username,
          email: email,
          password: '', // No guardamos la contraseña
          role: role,
          name: name,
          surname: surname,
          profilePicture: profilePicture,
          createdRecipes: [],
          createdFestivals: [],
          createdPlaces: [],
          reviews: [],
        );
      }
    } catch (e) {
      print("Error leyendo el usuario: $e");
    }
    return null;
  }
}
