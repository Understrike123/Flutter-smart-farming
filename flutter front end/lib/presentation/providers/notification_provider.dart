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
  List<AppNotification> get filteredNotifications {
    return _allNotifications;
  }

  NotificationFilter _currentFilter = NotificationFilter.semua;
  NotificationFilter get currentFilter => _currentFilter;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    // Kirim filter yang sedang aktif ke use case
    final result = await getNotifications(_currentFilter.name);
    _allNotifications = []; // Kosongkan dulu untuk menghindari data lama

    // PERBAIKAN: Tambahkan tipe data eksplisit pada parameter lambda
    result.fold(
      (Failure failure) => print(failure.message),
      (List<AppNotification> notificationList) =>
          _allNotifications = notificationList,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(int notificationId) async {
    final index = _allNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_allNotifications[index].isRead) {
      _allNotifications[index].isRead = true;
      await markNotificationAsRead(notificationId);
      fetchNotifications();
    }
  }

  void setFilter(NotificationFilter filter) {
    _currentFilter = filter;
    fetchNotifications();
  }
}
