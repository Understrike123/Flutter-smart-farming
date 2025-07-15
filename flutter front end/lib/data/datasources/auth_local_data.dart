import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalData {
  Future<void> saveAuthToken(String token);

  Future<void> clearAuthtoken();
}

class AuthLocalDataImpl implements AuthLocalData {
  final SharedPreferences sharedPreferences;

  AuthLocalDataImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(String token) {
    return sharedPreferences.setString('authToken', token);
  }

  @override
  Future<void> clearAuthtoken() {
    return sharedPreferences.remove('authToken');
  }
}
