import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smarthome/presentation/providers/sensor_provider.dart';
import 'package:flutter_smarthome/presentation/screens/sensor_detail_screen.dart';
import '../shared/sensor_card.dart';

class SensorGridSection extends StatefulWidget {
  const SensorGridSection({super.key});

  @override
  State<SensorGridSection> createState() => _SensorGridSectionState();
}

class _SensorGridSectionState extends State<SensorGridSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SensorProvider>(context, listen: false).fetchSensors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingSensors) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: provider.sensors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final sensor = provider.sensors[index];
            return SensorCard(
              iconPath: sensor.iconPath,
              value: sensor.value + sensor.unit,
              label: sensor.statusLabel,
              iconColor: sensor.color,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SensorDetailScreen(sensor: sensor),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
