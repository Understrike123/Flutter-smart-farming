import 'package:flutter/material.dart';
import '../../../domain/entities/sensor.dart';
import '../../screens/sensor_detail_screen.dart';
import '../shared/sensor_card.dart';

class SensorGridSection extends StatelessWidget {
  final List<Sensor> sensors; // Terima data dari luar

  const SensorGridSection({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    final sensorsPreview = sensors.take(4).toList();
    // Langsung gunakan GridView.builder untuk menampilkan data yang diterima
    return Column(
      children: [
        if (sensorsPreview.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Tidak ada sensor'),
            ),
          )
        else
          GridView.builder(
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
              // ignore: non_constant_identifier_names
              return SensorCard(
                iconPath: sensor.iconPath,
                value: sensor.value,
                unit: sensor.unit,
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
          ),
      ],
    );
  }
}
