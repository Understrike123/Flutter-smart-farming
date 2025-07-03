import 'package:flutter/foundation.dart';
import '../../domain/entities/notification.dart';
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
    switch (_currentFilter) {
      case NotificationFilter.penting:
        return _allNotifications
            .where((n) => n.type == NotificationType.warning)
            .where((n) => n.type == NotificationType.danger)
            .toList();
      case NotificationFilter.belumDibaca:
        return _allNotifications.where((n) => !n.isRead).toList();
      case NotificationFilter.semua:
      default:
        return _allNotifications;
    }
  }

  NotificationFilter _currentFilter = NotificationFilter.semua;
  NotificationFilter get currentFilter => _currentFilter;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    _allNotifications = await getNotifications();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _allNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_allNotifications[index].isRead) {
      _allNotifications[index].isRead = true;
      await markNotificationAsRead(notificationId);
      notifyListeners();
    }
  }

  void setFilter(NotificationFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }
}
