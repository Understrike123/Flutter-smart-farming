import 'package:either_dart/either.dart';
import 'package:flutter_smarthome/data/datasources/actuator_remote_data_source.dart';
import 'package:flutter_smarthome/data/repositories/data_failure_repository.dart';
import 'package:flutter_smarthome/data/repositories/error_exceptions.dart';

import '../../domain/entities/actuator.dart';
import '../../domain/repositories/actuator_repository.dart';

class ActuatorRepositoryImpl implements ActuatorRepository {
  final ActuatorRemoteDataSource remoteDataSource;

  ActuatorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Actuator>>> getActuators() async {
    try {
      final actuators = await remoteDataSource.getActuators();
      return Right(actuators);
    } on ServerException {
      return const Left(ServerFailure('Gagal mengambil data aktuator.'));
    }
  }

  @override
  Future<Either<Failure, void>> createActuator(
    Map<String, dynamic> actuatorData,
  ) async {
    try {
      await remoteDataSource.createActuator(actuatorData);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Gagal membuat aktuator.'));
    }
  }

  @override
  Future<Either<Failure, void>> postActuatorCommand(
    int actuatorId,
    String command,
  ) async {
    try {
      await remoteDataSource.postCommand(actuatorId, command);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure('Gagal mengirim perintah'));
    }
  }
}
