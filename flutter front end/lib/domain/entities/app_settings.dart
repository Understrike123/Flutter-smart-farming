import 'notification_pref.dart';
import 'setting_threshold.dart';

class AppSettings {
  final List<SettingThreshold> thresholds;
  final NotificationPref notificationPref;

  AppSettings({required this.thresholds, required this.notificationPref});

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      thresholds:
          (json['thresholds'] as List<dynamic>?)
              ?.map((item) => SettingThreshold.fromJson(item))
              .toList() ??
          [],

      notificationPref: NotificationPref.fromJson(
        json['notification_preferences'] ?? {},
      ),
    );
  }
}
