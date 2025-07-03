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
  bool isRead; // <-- TAMBAHAN PENTING

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timestamp,
    this.isRead = false, // Defaultnya, notifikasi belum dibaca
  });
}
