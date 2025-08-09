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

  final Set<int> _updatingActuatorIds = {};
  bool isUpdating(int actuatorId) => _updatingActuatorIds.contains(actuatorId);

  // Method untuk memuat data awal
  Future<void> fetchActuators() async {
    debugPrint("PROVIDER: Memulai fetchActuators...");
    _isLoading = true;
    notifyListeners();
    final result = await getActuators();
    debugPrint(
      "PROVIDER: Selesai memanggil use case, hasilnya: ${result.isRight ? 'Sukses' : 'Gagal'}",
    );
    result.fold(
      (failure) => print(failure.message),
      (actuatorList) => _actuators = actuatorList,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendCommand(int actuatorId, String command) async {
    // PERBAIKAN 2: Hapus pembaruan optimis, ganti dengan state loading
    _updatingActuatorIds.add(actuatorId);
    notifyListeners();

    final result = await postActuatorCommand(actuatorId, command);

    result.fold(
      (failure) {
        print(failure.message);
        // Tampilkan pesan error jika perlu
      },
      (_) {
        // Jika sukses, tidak perlu melakukan apa-apa karena fetch di bawah akan memperbarui
      },
    );

    // PERBAIKAN 3: Hapus ID dari set loading dan panggil fetch untuk mendapatkan data terbaru
    _updatingActuatorIds.remove(actuatorId);
    // Panggil fetchActuators untuk mendapatkan state yang sudah pasti dari server
    await fetchActuators();
  }
}
