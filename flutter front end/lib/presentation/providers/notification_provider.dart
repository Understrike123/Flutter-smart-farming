import 'package:flutter/foundation.dart';
import '../../domain/entities/notification.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

enum NotificationFilter { semua, penting, belumDibaca }

class NotificationProvider with ChangeNotifier {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;

  NotificationProvider({
    required this.getNotifications,
    required this.markNotificationAsRead,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AppNotification> _allNotifications = [];

  // Getter ini sekarang benar-benar melakukan filtering
  List<AppNotification> get filteredNotifications {
    switch (_currentFilter) {
      case NotificationFilter.belumDibaca:
        // Beri tipe data eksplisit untuk membantu analyzer Dart
        return _allNotifications
            .where((AppNotification n) => n.isRead == false)
            .toList();

      case NotificationFilter.penting:
        // Lakukan hal yang sama di sini
        return _allNotifications
            .where((AppNotification n) => n.severity == 'CRITICAL')
            .toList();

      case NotificationFilter.semua:
        return _allNotifications;
    }
  }

  NotificationFilter _currentFilter = NotificationFilter.semua;
  NotificationFilter get currentFilter => _currentFilter;

  // Method ini hanya perlu dipanggil sekali saat halaman dibuka
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    // Selalu ambil semua notifikasi, biarkan filtering dilakukan di aplikasi
    final result = await getNotifications('semua');
    _allNotifications = [];

    result.fold(
      // Tipe 'Failure' sekarang akan diambil dari file yang diimpor
      (Failure failure) => print(failure.message),
      (List<AppNotification> notificationList) =>
          _allNotifications = notificationList,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(int notificationId) async {
    // Dan juga di sini
    final index = _allNotifications.indexWhere(
      (AppNotification n) => n.id == notificationId,
    );
    if (index != -1 && !_allNotifications[index].isRead) {
      // Update state secara optimis agar UI langsung berubah
      _allNotifications[index].isRead = true;
      notifyListeners();

      // Kirim request ke backend di latar belakang
      await markNotificationAsRead(notificationId);
      // Tidak perlu fetch ulang, lebih efisien
    }
  }

  // Method ini sekarang jauh lebih cepat
  void setFilter(NotificationFilter filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      // Cukup panggil notifyListeners(), tidak perlu panggil API lagi
      notifyListeners();
    }
  }
}
