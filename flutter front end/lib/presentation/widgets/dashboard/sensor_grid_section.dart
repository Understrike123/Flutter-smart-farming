import 'package:flutter/material.dart';
import '../../../domain/entities/sensor.dart';
import '../../screens/sensor_detail_screen.dart';
import '../shared/sensor_card.dart';

class SensorGridSection extends StatelessWidget {
  final List<Sensor> sensors; // Terima data dari luar

  const SensorGridSection({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    // Langsung gunakan GridView.builder untuk menampilkan data yang diterima
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: sensors.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final sensor = sensors[index];
        return SensorCard(
          iconPath: sensor.iconPath,
          value: sensor.value + sensor.unit,
          label: sensor.statusLabel,
          iconColor: sensor.color,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Kirim objek sensor lengkap ke halaman detail
                builder: (context) => SensorDetailScreen(sensor: sensor),
              ),
            );
          },
        );
      },
    );
  }
}
