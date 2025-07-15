import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smarthome/domain/usecases/logout_user.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final LogoutUser logoutUser;

  AuthProvider({required this.loginUser, required this.logoutUser});

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    final result = await loginUser.call(email, password);

    result.fold(
      (failure) {
        // jika login gagal
        _errorMessage = failure.message;
        _state = AuthState.error;
      },
      (user) {
        // Jika login sukses
        _state = AuthState.success;
      },
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    await logoutUser();

    _state = AuthState.initial;
    notifyListeners();
  }

  // fungsi untuk reset state setelah terjadi error login
  void resetState() {
    _state = AuthState.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
