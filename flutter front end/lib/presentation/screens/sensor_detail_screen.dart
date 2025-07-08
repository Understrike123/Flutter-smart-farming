import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smarthome/domain/entities/sensor.dart';
import 'package:flutter_smarthome/presentation/providers/sensor_provider.dart';
import '../widgets/sensor_detail/detailed_stats_section.dart';
import '../widgets/sensor_detail/historical_chart_section.dart';
import '../widgets/sensor_detail/sensor_selector.dart';

class SensorDetailScreen extends StatefulWidget {
  final Sensor sensor;
  const SensorDetailScreen({super.key, required this.sensor});

  @override
  State<SensorDetailScreen> createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SensorProvider>(
        context,
        listen: false,
      ).fetchSensorHistory(widget.sensor.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: Text(widget.sensor.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Historis: ${widget.sensor.name}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const HistoricalChartSection(),
              const SizedBox(height: 24),
              DetailedStatsSection(sensor: widget.sensor),
            ],
          ),
        ),
      ),
    );
  }
}
