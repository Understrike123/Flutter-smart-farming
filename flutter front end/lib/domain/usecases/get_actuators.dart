import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/actuator.dart';
import '../repositories/actuator_repository.dart';

class GetActuators {
  final ActuatorRepository repository;
  GetActuators(this.repository);

  Future<Either<Failure, List<Actuator>>> call() {
    return repository.getActuators();
  }
}
