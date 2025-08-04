enum NotificationType {
  danger, // untuk peringatan kritis
  warning, // Untuk peringatan tahap 1
  info, // Untuk informasi biasa
  success, // Untuk notifikasi keberhasilan
}

class AppNotification {
  final String id;
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

  // TAMBAHKAN FACTORY CONSTRUCTOR INI
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
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      subtitle: json['subtitle'] ?? '',
      type: _parseType(json['type']),
      // Parsing timestamp dari string format ISO 8601
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }
}
