enum ActuatorStatus { aktif, nonaktif }

class Actuator {
  final String title;
  final String iconPath;
  final bool hasAdvancedControls;
  ActuatorStatus status;
  String mode;

  Actuator({
    required this.title,
    this.iconPath = '',
    this.hasAdvancedControls = false,
    this.status = ActuatorStatus.nonaktif,
    this.mode = "OTOMATIS",
  });

  // TAMBAHKAN FACTORY CONSTRUCTOR INI
  factory Actuator.fromJson(Map<String, dynamic> json) {
    return Actuator(
      title: json['name'] ?? 'Aktuator Tidak Dikenal',
      // Logika untuk mengubah status dari string ke enum
      status: (json['status']?.toString().toLowerCase() == 'aktif')
          ? ActuatorStatus.aktif
          : ActuatorStatus.nonaktif,
      mode: json['mode'] ?? 'OTOMATIS',
      // Anda bisa menambahkan properti lain di JSON jika perlu
      // iconPath: json['icon_path'],
      // hasAdvancedControls: json['has_advanced_controls'],
    );
  }
}
