import 'package:flutter/material.dart';
import 'package:flutter_smarthome/domain/entities/sensor.dart';
import 'sensor_detail_screen.dart';
import '../../../domain/entities/sensor.dart';
import '../widgets/shared/sensor_card.dart';
import '../widgets/dashboard/sensor_grid_section.dart';

class AllSensorScreen extends StatelessWidget {
  final List<Sensor> sensors; // Terima data dari luar

  const AllSensorScreen({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Sensor')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
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
                        builder: (context) =>
                            SensorDetailScreen(sensor: sensor),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
