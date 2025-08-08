import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  Future<void> call(int notificationId) {
    return repository.markAsRead(notificationId);
  }
}
