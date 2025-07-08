import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/sensor.dart';
import '../repositories/sensor_repository.dart';

class GetSensor {
  final SensorRepository repository;
  GetSensor(this.repository);

  Future<Either<Failure, List<Sensor>>> call() {
    return repository.getSensor();
  }
}
