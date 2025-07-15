import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
