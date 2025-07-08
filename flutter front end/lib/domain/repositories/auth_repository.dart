import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Kontrak untuk login: butuh email & password,
  // akan mengembalikan Failure (kiri) atau User (kanan)
  Future<Either<Failure, User>> login(String email, String password);

  // Nanti bisa ditambahkan:
  // Future<void> logout();
}
