import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalData {
  Future<void> saveAuthToken(String token);
}

class AuthLocalDataImpl implements AuthLocalData {
  final SharedPreferences sharedPreferences;

  AuthLocalDataImpl({required this.sharedPreferences});

  @override
  Future<void> saveAuthToken(String token) {
    return sharedPreferences.setString('authToken', token);
  }
}
