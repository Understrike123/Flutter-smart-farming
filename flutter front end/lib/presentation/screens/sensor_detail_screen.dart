import 'package:flutter/material.dart';
import '../widgets/sensor_detail/detailed_stats_section.dart';
import '../widgets/sensor_detail/historical_chart_section.dart';
import '../widgets/sensor_detail/sensor_selector.dart';

class SensorDetailScreen extends StatelessWidget {
  const SensorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna background yang sama dengan dasbor
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(
        title: const Text('Detail Sensor'),
        // Tombol kembali akan muncul secara otomatis oleh Navigator
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SensorSelector(),
              SizedBox(height: 24),
              HistoricalChartSection(),
              SizedBox(height: 24),
              DetailedStatsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
