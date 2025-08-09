import 'package:either_dart/either.dart';
import '../repositories/actuator_repository.dart';
import '../../data/repositories/data_failure_repository.dart';

class CreateActuator {
  final ActuatorRepository repository;
  CreateActuator(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> actuatorData) {
    return repository.createActuator(actuatorData);
  }
}
