import 'package:flutter_smarthome/presentation/widgets/actuator_controll/actuator_card.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/actuator.dart';
import 'package:either_dart/either.dart';

abstract class ActuatorRepository {
  // /kontrak untuk mendapatkan daftar semua aktuator
  Future<Either<Failure, List<Actuator>>> getActuators();
  Future<Either<Failure, void>> postActuatorCommand(
    int actuatorId,
    String command,
  );
  Future<Either<Failure, void>> createActuator(
    Map<String, dynamic> actuatorData,
  );
}
