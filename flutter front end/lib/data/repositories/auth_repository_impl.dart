import 'package:either_dart/either.dart';
import '../../domain/entities/user.dart';
import '../repositories/data_failure_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalData localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulasi delay untuk proses login

    if (email == 'admin@gmail.com' && password == 'admin') {
      final user = User(
        id: 'user-123',
        name: 'Admin Febrian Fritz',
        email: email,
        token: 'dummy-jwt-token-xyz',
      );
      // Simpan token ke local storage
      await localDataSource.saveAuthToken(user.token);
      return Right(user); // Kembalikan user jika login sukses
    } else {
      // mengembalikan kegagalan jika email atau password salah
      return const Left(ServerFailure('Email atau password salah'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthtoken();
      return const Right(null);
    } catch (error) {
      return const Left(ServerFailure('Gagal Sign Out'));
    }
  }
}
