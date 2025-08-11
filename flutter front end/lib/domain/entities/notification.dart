enum NotificationType { danger, warning, info, success }

// Nama kelas ini harus sama dengan yang Anda gunakan di seluruh aplikasi.
// Jika Anda menggunakan 'Notification', ganti nama 'AppNotification' menjadi 'Notification'.
class AppNotification {
  final int id;
  final String title;
  final String subtitle;
  final NotificationType type;
  final String severity; // PERBAIKAN 1: Tambahkan properti severity
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.severity, // PERBAIKAN 2: Tambahkan di constructor
    required this.timestamp,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
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
      id: json['id'] ?? 0,
      title: json['message'] ?? 'Tanpa Judul',
      subtitle: '',
      type: _parseType(json['type']),
      // PERBAIKAN 3: Ambil nilai 'severity' dari JSON
      severity: json['severity'] ?? 'INFO',
      timestamp: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] == 1,
    );
  }
}
