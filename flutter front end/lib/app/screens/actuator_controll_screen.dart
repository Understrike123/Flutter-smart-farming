import 'package:flutter/material.dart';
import '../../widgets/actuator_controll/actuator_card.dart';

class ActuatorControllScreen extends StatelessWidget {
  const ActuatorControllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: const Text('Kontrol Aktuator')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ActuatorCard(
            title: 'Sistem Irigasi Utama',
            iconPath: 'assets/icons/drop.png',
            hasAdvancedControls: true,
          ),
          SizedBox(height: 16),

          ActuatorCard(
            title: 'Pompa Pupuk Cair',
            iconPath: 'assets/icons/fertilizer.png',
            hasAdvancedControls: true,
          ),

          SizedBox(height: 16),

          ActuatorCard(
            title: 'Sistem Pencahayaan',
            iconPath: 'assets/icons/lampu.png',
            hasAdvancedControls: true,
          ),
          SizedBox(height: 16),

          ActuatorCard(
            title: 'Sistem Ventilasi',
            iconPath: 'assets/icons/ventilation.png',
            hasAdvancedControls: true,
          ),
        ],
      ),
    );
  }
}
