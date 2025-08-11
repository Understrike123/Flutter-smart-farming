import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../repositories/data_failure_repository.dart';
import '../repositories/error_exceptions.dart';
import '../datasources/notification_remote_data_source.dart';
import 'package:either_dart/either.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications(
    String filter,
  ) async {
    try {
      final notifications = await remoteDataSource.getNotifications(filter);
      return Right(notifications);
    } on ServerException {
      return const Left(ServerFailure('Gagal mengambil data notifikasi.'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Gagal menandai notifikasi'));
    }
  }
}
