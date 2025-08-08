import 'package:flutter/foundation.dart';
import 'package:flutter_smarthome/domain/usecases/get_actuators.dart';
import 'package:flutter_smarthome/domain/usecases/post_actuator_command.dart';
import '../../domain/entities/actuator.dart';
import '../../domain/repositories/actuator_repository.dart';

class ActuatorProvider with ChangeNotifier {
  final GetActuators getActuators;
  final PostActuatorCommand postActuatorCommand;

  // Constructor ini memungkinkan kita "menyuntikkan" implementasi repository
  ActuatorProvider({
    required this.getActuators,
    required this.postActuatorCommand,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Actuator> _actuators = [];
  List<Actuator> get actuators => _actuators;

  // Method untuk memuat data awal
  Future<void> fetchActuators() async {
    _isLoading = true;
    notifyListeners();
    final result = await getActuators();
    result.fold(
      (failure) => print(failure.message),
      (actuatorList) => _actuators = actuatorList,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendCommand(int actuatorId, String command) async {
    // Optimistic UI update (opsional, tapi membuat UI terasa lebih cepat)
    final index = _actuators.indexWhere((act) => act.id == actuatorId);
    if (index != -1) {
      _actuators[index].status = (command == 'TURN_ON')
          ? ActuatorStatus.aktif
          : ActuatorStatus.nonaktif;
      _actuators[index].mode = (command == 'TURN_ON') ? 'manual' : 'auto';
      notifyListeners();
    }

    final result = await postActuatorCommand(actuatorId, command);
    result.fold(
      (failure) {
        print(failure.message);
        // Jika gagal, kembalikan data ke kondisi semula
        fetchActuators();
      },
      (_) {
        // Jika sukses, muat ulang data untuk memastikan sinkronisasi
        fetchActuators();
      },
    );
  }
}
