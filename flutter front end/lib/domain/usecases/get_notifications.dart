import '../entities/notification.dart';
import '../repositories/notification_repository.dart';
import '../../data/repositories/data_failure_repository.dart';
import 'package:either_dart/either.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<Either<Failure, List<AppNotification>>> call(String filter) {
    return repository.getNotifications(filter);
  }
}
