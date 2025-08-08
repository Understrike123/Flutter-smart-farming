class AppSettings {
  final bool notificationsEnabled;
  final double soilMoistureThreshold;

  AppSettings({
    required this.notificationsEnabled,
    required this.soilMoistureThreshold,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notificationsEnabled: json['notifications_enabled'] ?? true,
      soilMoistureThreshold:
          (json['soil_moisture_threshold'] as num?)?.toDouble() ?? 25.0,
    );
  }

  // Method untuk menyalin objek dengan perubahan
  AppSettings copyWith({
    bool? notificationsEnabled,
    double? soilMoistureThreshold,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soilMoistureThreshold:
          soilMoistureThreshold ?? this.soilMoistureThreshold,
    );
  }
}
