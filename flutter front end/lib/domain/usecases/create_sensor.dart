import 'package:either_dart/either.dart';
import '../repositories/sensor_repository.dart';
import '../../data/repositories/data_failure_repository.dart';

class CreateSensor {
  final SensorRepository repository;
  CreateSensor(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> sensorData) {
    return repository.createSensor(sensorData);
  }
}
