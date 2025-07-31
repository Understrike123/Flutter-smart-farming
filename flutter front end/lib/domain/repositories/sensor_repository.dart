import 'package:either_dart/either.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../entities/sensor.dart';
import '../entities/sensor_history.dart';

abstract class SensorRepository {
  Future<Either<Failure, List<Sensor>>> getSensors();
  Future<Either<Failure, List<SensorHistory>>> getSensorHistory(
    String sensorId,
  );
}
