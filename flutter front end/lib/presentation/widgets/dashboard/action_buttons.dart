import 'package:flutter/material.dart';
import '../shared/action_card.dart';
import '../../screens/actuator_controll_screen.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionCard(
            icon: Icons.water_drop,
            label: 'Kontrol \nAktuator',
            onTap: () {
              // Navigasi ke halaman kontrol aktuator
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActuatorControlScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ActionCard(
            icon: Icons.bar_chart,
            label: 'Lihat Riwayat\nIrigasi',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
