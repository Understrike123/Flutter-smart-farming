import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateSettings {
  final SettingsRepository repository;
  UpdateSettings(this.repository);

  Future<Either<Failure, void>> call(AppSettings setting) {
    return repository.updateSettings(setting);
  }
}
