import 'package:flutter/foundation.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

import '../../domain/usecases/create_actuator.dart';
import '../../domain/usecases/create_sensor.dart';

class DashboardProvider with ChangeNotifier {
  final GetDashboardSummary getDashboardSummary;
  final CreateSensor createSensor;
  final CreateActuator createActuator;

  DashboardProvider({
    required this.getDashboardSummary,
    required this.createSensor,
    required this.createActuator,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAddingDevice = false;
  bool get isAddingDevice => _isAddingDevice;

  DashboardSummary? _dashboardSummary;
  DashboardSummary? get dashboardSummary => _dashboardSummary;

  Future<void> fetchDashboardSummary() async {
    _isLoading = true;
    notifyListeners();
    final result = await getDashboardSummary();
    result.fold(
      (failure) => print(failure.message),
      (summary) => _dashboardSummary = summary,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addSensor(Map<String, dynamic> sensorData) async {
    _isAddingDevice = true;
    notifyListeners();

    final result = await createSensor(sensorData);
    bool success = false;
    result.fold((failure) => success = false, (_) => success = true);

    _isAddingDevice = false;
    if (success) {
      fetchDashboardSummary(); // Muat ulang data dasbor
    }
    notifyListeners();
    return success;
  }

  Future<bool> addActuator(Map<String, dynamic> actuatorData) async {
    _isAddingDevice = true;
    notifyListeners();

    final result = await createActuator(actuatorData);
    bool success = false;
    result.fold((failure) => success = false, (_) => success = true);

    _isAddingDevice = false;
    if (success) {
      fetchDashboardSummary();
    }
    notifyListeners();
    return success;
  }
}
