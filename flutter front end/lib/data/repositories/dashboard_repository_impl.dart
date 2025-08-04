import 'package:either_dart/either.dart';
import '../repositories/data_failure_repository.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    try {
      final summary = await remoteDataSource.getDashboardSummary();
      return Right(summary);
    } on ServerException {
      return const Left(ServerFailure('Gagal memuat data dasbor.'));
    }
  }
}
