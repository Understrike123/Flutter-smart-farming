import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/data_failure_repository.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/entities/sensor_history.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/sensor_remote_data_source.dart';
import './error_exceptions.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource remoteDataSource;

  SensorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Sensor>>> getSensors() async {
    try {
      final sensors = await remoteDataSource.getSensors();
      return Right(sensors);
    } on ServerException {
      return const Left(
        ServerFailure('Gagal mengambil data sensor dari server.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<SensorHistory>>> getSensorHistory(
    String sensorId,
  ) async {
    // TODO: Implementasi pengambilan data riwayat dari API
    // Untuk saat ini, kita bisa kembalikan data dummy atau list kosong
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right([]); // Kembalikan list kosong untuk sementara
  }
}
  // final List<Sensor> _sensor = [
    // Sensor(
    //   id: 'soil_moisture_1',
    //   name: 'Kelembaban Tanah',
    //   value: '68',
    //   unit: '%',
    //   statusLabel: 'Normal',
    //   iconPath: 'assets/icons/plant.png',
    //   color: const Color(0xFF5E8C61),
    //   average: 62,
    //   min: 35,
    //   max: 80,
    // ),
    // Sensor(
    //   id: 'humidity_1',
    //   name: 'Kelembaban Udara',
    //   value: '78',
    //   unit: '%',
    //   statusLabel: 'Baik',
    //   iconPath: 'assets/icons/cloud.png',
    //   color: Colors.blue,
    //   average: 75,
    //   min: 60,
    //   max: 85,
    // ),
    // Sensor(
    //   id: 'light_intensity_1',
    //   name: 'Intensitas Cahaya',
    //   value: '9.200',
    //   unit: ' Lux',
    //   statusLabel: 'Cukup',
    //   iconPath: 'assets/icons/lampu.png',
    //   color: Colors.amber,
    //   average: 8500,
    //   min: 5000,
    //   max: 12000,
    // ),
    // Sensor(
    //   id: 'soil_moisture_2',
    //   name: 'Kelembaban Tanah',
    //   value: '50',
    //   unit: '%',
    //   statusLabel: 'Normal',
    //   iconPath: 'assets/icons/plant.png',
    //   color: const Color(0xFF5E8C61),
    //   average: 62,
    //   min: 40,
    //   max: 90,
    // ),
   
  

//   final Map<String, List<SensorHistory>> _historyData = {
//     'soil_moisture_1': [
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 12)),
//         value: 70,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 10)),
//         value: 55,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 8)),
//         value: 40,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 6)),
//         value: 50,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 4)),
//         value: 35,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//         value: 50,
//       ),
//       SensorHistory(timestamp: DateTime.now(), value: 68),
//     ],
//     'soil_moisture_2': [
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 12)),
//         value: 70,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 10)),
//         value: 55,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 8)),
//         value: 40,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 6)),
//         value: 50,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 4)),
//         value: 35,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//         value: 50,
//       ),
//       SensorHistory(timestamp: DateTime.now(), value: 68),
//     ],
//     'temperature_1': [
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 12)),
//         value: 28,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 10)),
//         value: 29,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 8)),
//         value: 31,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 6)),
//         value: 30,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 4)),
//         value: 28,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//         value: 27,
//       ),
//       SensorHistory(timestamp: DateTime.now(), value: 29),
//     ],
//     'humidity_1': [
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 12)),
//         value: 80,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 10)),
//         value: 82,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 8)),
//         value: 75,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 6)),
//         value: 70,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 4)),
//         value: 74,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//         value: 76,
//       ),
//       SensorHistory(timestamp: DateTime.now(), value: 78),
//     ],
//     'light_intensity_1': [
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 12)),
//         value: 5000,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 10)),
//         value: 8000,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 8)),
//         value: 12000,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 6)),
//         value: 11000,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 4)),
//         value: 9000,
//       ),
//       SensorHistory(
//         timestamp: DateTime.now().subtract(const Duration(hours: 2)),
//         value: 7000,
//       ),
//       SensorHistory(timestamp: DateTime.now(), value: 9200),
//     ],
//   };
//   @override
//   Future<Either<Failure, List<Sensor>>> getSensor() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return Right(_sensors);
//   }

//   @override
//   Future<Either<Failure, List<SensorHistory>>> getSensorHistory(
//     String sensorId,
//   ) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     if (_historyData.containsKey(sensorId)) {
//       return Right(_historyData[sensorId]!);
//     } else {
//       return const Left(ServerFailure('Data riwayat tidak ditemukan.'));
//     }
//   }
// }
