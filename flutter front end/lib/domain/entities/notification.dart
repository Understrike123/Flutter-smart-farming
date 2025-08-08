enum NotificationType {
  danger, // untuk peringatan kritis
  warning, // Untuk peringatan tahap 1
  info, // Untuk informasi biasa
  success, // Untuk notifikasi keberhasilan
}

class AppNotification {
  // PERBAIKAN: Ubah tipe data id dari String menjadi int
  final int id;
  final String title;
  final String subtitle;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // Fungsi helper untuk mengubah string tipe menjadi enum
    NotificationType _parseType(String? typeStr) {
      switch (typeStr?.toLowerCase()) {
        case 'penting':
          return NotificationType.warning;
        case 'sukses':
          return NotificationType.success;
        default:
          return NotificationType.info;
      }
    }

    return AppNotification(
      // PERBAIKAN: Baca 'id' sebagai int
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      subtitle: json['subtitle'] ?? '',
      type: _parseType(json['type']),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }
}
