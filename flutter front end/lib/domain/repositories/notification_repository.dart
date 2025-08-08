import '../entities/notification.dart';
import '../../data/repositories/data_failure_repository.dart';
import 'package:either_dart/either.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications(
    String filter,
  );
  Future<Either<Failure, void>> markAsRead(int notificationId);
}
