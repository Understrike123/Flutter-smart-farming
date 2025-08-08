import 'package:either_dart/either.dart';
import 'package:http/retry.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../repositories/actuator_repository.dart';

class PostActuatorCommand {
  final ActuatorRepository repository;
  PostActuatorCommand(this.repository);

  Future<Either<Failure, void>> call(int actuatorId, String command) {
    return repository.postActuatorCommand(actuatorId, command);
  }
}
