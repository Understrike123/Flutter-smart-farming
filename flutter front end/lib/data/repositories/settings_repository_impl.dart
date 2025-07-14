import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences sharedPreferences;

  SettingsRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final notifications =
          sharedPreferences.getBool('notificationsEnabled') ?? true;
      final threshold =
          sharedPreferences.getDouble('soilMoistureThreshold') ?? 25.0;

      return Right(
        AppSettings(
          notificationEnabled: notifications,
          soilMoistureThreshold: threshold,
        ),
      );
    } catch (error) {
      return const Left(ServerFailure('Gagal loading setting'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      // simpan data ke local storage
      await sharedPreferences.setBool(
        'notificationsEnabled',
        settings.notificationEnabled,
      );
      await sharedPreferences.setDouble(
        'soilMoistureThreshold',
        settings.soilMoistureThreshold,
      );
      return const Right(null);
    } catch (error) {
      return const Left(ServerFailure('Gagal menyimpan pengaturan'));
    }
  }
}
