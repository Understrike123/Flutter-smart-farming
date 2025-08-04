import 'package:flutter_smarthome/presentation/widgets/actuator_controll/actuator_card.dart';

import '../entities/actuator.dart';

abstract class ActuatorRepository {
  // /kontrak untuk mendapatkan daftar semua aktuator
  List<Actuator> getActuators();

  // kontrak untuk mengubah status aktuator
  void updateActuatorStatus(String title, ActuatorStatus newStatus);
}
