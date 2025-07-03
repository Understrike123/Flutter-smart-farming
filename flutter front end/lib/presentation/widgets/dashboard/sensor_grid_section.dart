import 'package:flutter/material.dart';
import '../../screens/sensor_detail_screen.dart';

import '../shared/sensor_card.dart';

class SensorGridSection extends StatelessWidget {
  const SensorGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio:
          1.1, // Sedikit penyesuaian untuk tampilan yang lebih baik
      children: [
        SensorCard(
          iconPath: 'assets/icons/plant.png', // Ganti dengan path icon Anda
          value: '68%',
          label: 'Normal',
          iconColor: const Color(0xFF5E8C61),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorDetailScreen(),
              ),
            );
          },
        ),
        SensorCard(
          iconPath: 'assets/icons/temperature.png',
          value: '29°C',
          label: 'Ideal',
          iconColor: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorDetailScreen(),
              ),
            );
          },
        ),
        SensorCard(
          iconPath: 'assets/icons/cloud.png',
          value: '78%',
          label: 'Baik',
          iconColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorDetailScreen(),
              ),
            );
          },
        ),
        SensorCard(
          iconPath: 'assets/icons/leaf.png',
          value: '9.200 Lux',
          label: 'Cukup',
          iconColor: Colors.amber,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorDetailScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
