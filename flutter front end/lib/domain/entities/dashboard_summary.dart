import 'actuator.dart';
import 'notification.dart';
import 'sensor.dart';

class DashboardSummary {
  final List<Sensor> sensors;
  final List<Actuator> actuators;
  final List<AppNotification> notifications;

  DashboardSummary({
    required this.sensors,
    required this.actuators,
    required this.notifications,
  });

  // Factory untuk membuat dari JSON
  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      sensors:
          (json['current_sensors'] as List<dynamic>?)
              ?.map((item) => Sensor.fromJson(item))
              .toList() ??
          [],
      actuators:
          (json['actuator_status'] as List<dynamic>?)
              ?.map(
                (item) => Actuator.fromJson(item),
              ) // Kita perlu menambahkan fromJson ke Actuator
              .toList() ??
          [],
      notifications:
          (json['latest_notifications'] as List<dynamic>?)
              ?.map(
                (item) => AppNotification.fromJson(item),
              ) // Kita perlu menambahkan fromJson ke AppNotification
              .toList() ??
          [],
    );
  }
}
