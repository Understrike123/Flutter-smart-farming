import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/actuator.dart';
import '../providers/actuator_provider.dart';
import '../widgets/actuator_controll/actuator_card.dart';

// 1. Ubah menjadi StatefulWidget untuk memuat data saat pertama kali dibuka
class ActuatorControlScreen extends StatefulWidget {
  const ActuatorControlScreen({super.key});

  @override
  State<ActuatorControlScreen> createState() => _ActuatorControlScreenState();
}

class _ActuatorControlScreenState extends State<ActuatorControlScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Minta Provider untuk memuat data saat halaman pertama kali dibuka
    // listen: false diperlukan di dalam initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActuatorProvider>(context, listen: false).loadActuators();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: const Text('Kontrol Aktuator')),
      // 3. Gunakan Consumer untuk mendengarkan perubahan dari Provider
      body: Consumer<ActuatorProvider>(
        builder: (context, actuatorProvider, child) {
          final actuators = actuatorProvider.actuators;

          // 4. Gunakan ListView.builder untuk menampilkan data secara dinamis
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: actuators.length,
            itemBuilder: (context, index) {
              final actuator = actuators[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ActuatorCard(
                  actuatorData: actuator,
                  // 5. Teruskan fungsi untuk mengubah status ke Provider
                  onStatusChanged: (ActuaratorStatus newStatus) {
                    actuatorProvider.updateActuatorStatus(
                      actuator.title,
                      newStatus,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
