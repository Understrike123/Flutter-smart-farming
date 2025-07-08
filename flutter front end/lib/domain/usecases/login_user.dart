import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  // 'call' memungkinkan kita memanggil kelas ini seperti sebuah fungsi
  Future<Either<Failure, User>> call(String email, String password) {
    return repository.login(email, password);
  }
}
