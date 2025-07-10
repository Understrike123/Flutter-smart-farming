import 'package:flutter/foundation.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_settings.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettings getSettings;
  final UpdateSettings updateSettings;

  SettingsProvider({required this.getSettings, required this.updateSettings});

  AppSettings? _settings;
  AppSettings? get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();
    final result = await getSettings();
    result.fold(
      (failure) => print(failure.message),
      (settingsData) => _settings = settingsData,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateNotificationSetting(bool isEnabled) async {
    if (_settings == null) return;
    final newSettings = AppSettings(
      notificationEnabled: isEnabled,
      soilMoistureThreshold: _settings!.soilMoistureThreshold,
    );
    _settings = newSettings;
    notifyListeners();
    await updateSettings(newSettings);
  }

  Future<void> updateThresholdSetting(double threshold) async {
    if (_settings == null) return;
    final newSettings = AppSettings(
      notificationEnabled: _settings!.notificationEnabled,
      soilMoistureThreshold: threshold,
    );
    _settings = newSettings;
    notifyListeners();
    await updateSettings(newSettings);
  }
}
