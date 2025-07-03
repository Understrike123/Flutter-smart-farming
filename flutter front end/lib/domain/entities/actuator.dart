enum ActuaratorStatus { aktif, nonaktif }

class Actuator {
  final String title;
  final String iconPath;
  final bool hasAdvancedControls;
  ActuaratorStatus status;
  String mode;

  Actuator({
    required this.title,
    this.iconPath = '',
    this.hasAdvancedControls = false,
    this.status = ActuaratorStatus.nonaktif,
    this.mode = "OTOMATIS",
  });
}
