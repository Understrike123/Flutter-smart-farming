import 'package:either_dart/either.dart';
import 'package:flutter_smarthome/data/datasources/auth_remote_data_sources.dart';
import 'package:flutter_smarthome/data/repositories/error_exceptions.dart';
import '../../domain/entities/user.dart';
import '../repositories/data_failure_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalData localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);

      await localDataSource.saveAuthToken((user.token));

      return Right(user);
    } on ServerException {
      return const Left(
        ServerFailure('Email atau password salah. Silahkan coba lagi.'),
      );
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
