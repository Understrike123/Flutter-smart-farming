import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      title: 'Kelembaban Tanah Rendah',
      subtitle: 'Zona 2 - Perlu Penyiraman ',
      type: NotificationType.warning,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 2,
      title: 'Suhu Udara Tinggi Terdeteksi',
      subtitle: 'Suhu mencapai 35°C',
      type: NotificationType.danger,
      timestamp: DateTime.now().subtract(Duration(days: 1, hours: 5)),
    ),
    AppNotification(
      id: 3,
      title: 'Siklus Irigasi Selesai',
      subtitle: 'Irigasi otomatis Zona 1 telah selesai.',
      type: NotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      isRead: true,
    ),
    AppNotification(
      id: 4,
      title: 'Pompa Irigasi Gagal Beroperasi',
      subtitle: 'Zona 1 - Cek koneksi pompa.',
      type: NotificationType.warning,
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      isRead: true,
    ),
    AppNotification(
      id: 5,
      title: 'Pupuk Cair Hampir Habis',
      subtitle: 'Sisa pupuk cair tinggal 15%.',
      type: NotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
    ),
  ];

  @override
  Future<List<AppNotification>> getNotifications() async {
    // Mensimulasikan panggilan API
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return _notifications;
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }
}
