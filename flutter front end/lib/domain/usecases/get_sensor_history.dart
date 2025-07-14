import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/sensor_history.dart';
import '../repositories/sensor_repository.dart';

class GetSensorHistory {
  final SensorRepository repository;

  // konstraktor
  GetSensorHistory(this.repository);

  Future<Either<Failure, List<SensorHistory>>> call(String sensorId) {
    return repository.getSensorHistory(sensorId);
  }
}
