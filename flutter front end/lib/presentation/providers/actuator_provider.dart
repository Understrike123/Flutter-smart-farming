import 'package:flutter/foundation.dart';
import '../../domain/entities/actuator.dart';
import '../../domain/repositories/actuator_repository.dart';

class ActuatorProvider with ChangeNotifier {
  final ActuatorRepository _actuatorRepository;

  // Constructor ini memungkinkan kita "menyuntikkan" implementasi repository
  ActuatorProvider(this._actuatorRepository);

  List<Actuator> _actuators = [];
  List<Actuator> get actuators => _actuators;

  // Method untuk memuat data awal
  void loadActuators() {
    _actuators = _actuatorRepository.getActuators();
    notifyListeners();
  }

  // Method untuk mengubah status
  void updateActuatorStatus(String title, ActuaratorStatus newStatus) {
    _actuatorRepository.updateActuatorStatus(title, newStatus);
    // Kita panggil lagi loadActuators untuk mendapatkan data terbaru
    loadActuators();
  }
}
