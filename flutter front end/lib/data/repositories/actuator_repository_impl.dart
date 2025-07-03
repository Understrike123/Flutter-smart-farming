import '../../domain/entities/actuator.dart';
import '../../domain/repositories/actuator_repository.dart';

class ActuatorRepositoryImpl implements ActuatorRepository {
  final List<Actuator> _actuators = [
    Actuator(
      title: 'Sistem Irigasi Utama',
      iconPath: 'assets/icons/drop.png',
      hasAdvancedControls: true,
    ),
    Actuator(
      title: 'Pompa Pupuk Cair',
      iconPath: 'assets/icons/fertilizer.png',
    ),
    Actuator(title: 'Sistem Pencahayaan', iconPath: 'assets/icons/lampu.png'),
    Actuator(
      title: 'Sistem Ventilasi',
      iconPath: 'assets/icons/ventilation.png',
    ),
  ];
  @override
  List<Actuator> getActuators() {
    return _actuators;
  }

  @override
  void updateActuatorStatus(String title, ActuaratorStatus newStatus) {
    // NANTI: Ganti ini dengan panggilan API
    // Contoh: remoteDataSource.updateStatus(title, newStatus);
    try {
      final actuator = _actuators.firstWhere((act) => act.title == title);
      actuator.status = newStatus;
      actuator.mode = (newStatus == ActuaratorStatus.aktif)
          ? "MANUAL"
          : "OTOMATIS";
    } catch (e) {
      // Handle error
    }
  }
}
