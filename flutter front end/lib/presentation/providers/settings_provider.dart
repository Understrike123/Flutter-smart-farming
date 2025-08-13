import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/setting_threshold.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_settings.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/notification_pref.dart';

class SettingsProvider with ChangeNotifier {
  final GetSettings getSettings;
  final UpdateSettings updateSettings;

  SettingsProvider({required this.getSettings, required this.updateSettings});

  AppSettings? _settings;
  AppSettings? get settings => _settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

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

  // Method untuk memperbarui nilai threshold di state lokal
  void updateLocalThreshold(int id, {int? min, int? max}) {
    if (_settings == null) return;
    final index = _settings!.thresholds.indexWhere((t) => t.id == id);
    if (index != -1) {
      final oldThreshold = _settings!.thresholds[index];
      _settings!.thresholds[index] = SettingThreshold(
        id: oldThreshold.id,
        name: oldThreshold.name,
        thresholdMin: min ?? oldThreshold.thresholdMin,
        thresholdMax: max ?? oldThreshold.thresholdMax,
      );
      notifyListeners();
    }
  }

  // Method untuk memperbarui email di state lokal
  void updateLocalEmail(String? email) {
    if (_settings == null) return;
    _settings = AppSettings(
      thresholds: _settings!.thresholds,
      notificationPref: NotificationPref(email: email),
    );
    notifyListeners();
  }

  // Method untuk menyimpan semua perubahan ke backend
  Future<bool> saveSettings() async {
    if (_settings == null) return false;

    _isSaving = true;
    notifyListeners();

    final result = await updateSettings(_settings!);

    _isSaving = false;
    notifyListeners();

    return result.isRight; // true jika sukses, false jika gagal
  }
}
