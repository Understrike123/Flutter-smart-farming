import 'package:flutter/foundation.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/entities/sensor_history.dart';
import '../../domain/usecases/get_sensor_history.dart';
import '../../domain/usecases/get_sensor.dart';

class SensorProvider with ChangeNotifier {
  final GetSensor getSensors;
  final GetSensorHistory getSensorHistory;

  SensorProvider({required this.getSensors, required this.getSensorHistory});

  // state untuk daftar sensor di dashboard utama
  bool _isLoadingSensors = false;
  bool get isLoadingSensors => _isLoadingSensors;
  List<Sensor> _sensors = [];
  List<Sensor> get sensors => _sensors;

  // state untuk detail sensor
  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;
  List<SensorHistory> _history = [];
  List<SensorHistory> get history => _history;

  Future<void> fetchSensors() async {
    _isLoadingSensors = true;
    notifyListeners();
    final result = await getSensors();
    result.fold(
      (failure) => print(failure.message),
      (sensorList) => _sensors = sensorList,
    );
    _isLoadingSensors = false;
    notifyListeners();
  }

  Future<void> fetchSensorHistory(String sensorId) async {
    _isLoadingHistory = true;
    _history = [];
    notifyListeners();
    final result = await getSensorHistory(sensorId);
    result.fold(
      (failure) => print(failure.message),
      (historyList) => _history = historyList,
    );
    _isLoadingHistory = false;
    notifyListeners();
  }
}
