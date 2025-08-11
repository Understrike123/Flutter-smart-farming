enum ActuatorStatus { aktif, nonaktif }

class Actuator {
  // PERBAIKAN: Tambahkan field id dengan tipe int
  final int id;
  final String title;
  final String iconPath;
  final bool hasAdvancedControls;
  ActuatorStatus status;
  String mode;

  Actuator({
    required this.id,
    required this.title,
    this.iconPath = '',
    this.hasAdvancedControls = false,
    this.status = ActuatorStatus.nonaktif,
    this.mode = "OTOMATIS",
  });

  factory Actuator.fromJson(Map<String, dynamic> json) {
    return Actuator(
      // PERBAIKAN: Baca 'id' sebagai int
      id: json['id'] ?? 0,
      title: json['name'] ?? 'Aktuator Tidak Dikenal',
      // PERBAIKAN: Gunakan 'status' boolean dari JSON
      status: (json['status'] == 1)
          ? ActuatorStatus.aktif
          : ActuatorStatus.nonaktif,
      mode: json['mode'] ?? 'OTOMATIS',
      iconPath: _getIconPathFromName(json['name']),
    );
  }

  // Helper untuk menentukan ikon secara lokal berdasarkan nama
  static String _getIconPathFromName(String? name) {
    switch (name?.toLowerCase()) {
      case 'sistem irigasi utama':
        return 'assets/icons/water_drop.png';
      case 'pompa pupuk cair':
        return 'assets/icons/fertilizer.png';
      default:
        return 'assets/icons/actuator.png';
    }
  }
}
