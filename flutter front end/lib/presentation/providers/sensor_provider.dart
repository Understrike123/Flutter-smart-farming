import 'package:flutter/foundation.dart';
import '../../domain/entities/sensor.dart';
import '../../domain/entities/sensor_history.dart';
import '../../domain/usecases/get_sensor_history.dart';
import '../../domain/usecases/get_sensor.dart';
import 'dart:math' as math;

class SensorProvider with ChangeNotifier {
  final GetSensor getSensors;
  final GetSensorHistory getSensorHistory;

  SensorProvider({required this.getSensors, required this.getSensorHistory});

  // state untuk daftar sensor di dashboard utama
  bool _isLoadingSensors = false;
  bool get isLoadingSensors => _isLoadingSensors;
  List<Sensor> _sensors = [];
  List<Sensor> get sensors => _sensors;

  double _average = 0.0;
  double get average => _average;
  double _min = 0.0;
  double get min => _min;
  double _max = 0.0;
  double get max => _max;
  // state untuk detail sensor
  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;
  List<SensorHistory> _history = [];
  List<SensorHistory> get history => _history;

  void _calculateStatistics(List<SensorHistory> historyList) {
    if (historyList.isEmpty) {
      _average = 0.0;
      _min = 0.0;
      _max = 0.0;
      return;
    }

    final values = historyList.map((h) => h.value).toList();
    _average = values.reduce((a, b) => a + b) / values.length;
    _min = values.reduce(math.min);
    _max = values.reduce(math.max);
  }

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

  Future<void> fetchSensorHistory(int sensorId) async {
    _isLoadingHistory = true;
    _history = [];
    // Reset statistik saat memulai fetch baru
    _calculateStatistics([]);
    notifyListeners();

    final result = await getSensorHistory(sensorId);
    result.fold(
      (failure) {
        print(failure.message);
        // Biarkan statistik tetap 0 jika gagal
      },
      (historyList) {
        _history = historyList;
        // PERBAIKAN 3: Panggil fungsi kalkulasi setelah data berhasil diambil
        _calculateStatistics(historyList);
      },
    );
    _isLoadingHistory = false;
    notifyListeners();
  }
}
