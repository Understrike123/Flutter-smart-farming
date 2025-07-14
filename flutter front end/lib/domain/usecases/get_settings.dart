import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;
  GetSettings(this.repository);

  Future<Either<Failure, AppSettings>> call() {
    return repository.getSettings();
  }
}
