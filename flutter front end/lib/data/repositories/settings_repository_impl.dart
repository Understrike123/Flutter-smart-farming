import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../../domain/entities/setting_threshold.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';
import '../../domain/entities/app_settings.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await remoteDataSource.getSettings();
      return Right(settings);
    } on ServerException {
      return const Left(ServerFailure('Gagal memuat pengaturan.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      await remoteDataSource.updateSettings(settings);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Gagal menyimpan pengaturan.'));
    }
  }
}
