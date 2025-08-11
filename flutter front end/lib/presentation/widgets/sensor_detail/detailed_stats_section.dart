import 'package:flutter/material.dart';
import 'package:flutter_smarthome/domain/entities/sensor.dart';
import 'package:provider/provider.dart';
import '../../providers/sensor_provider.dart';

class DetailedStatsSection extends StatelessWidget {
  // Terima objek Sensor dari luar
  final Sensor sensor;

  const DetailedStatsSection({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, provider, child) {
        if (provider.history.isEmpty) {
          return const SizedBox.shrink();
        }
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistik Detail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // "Nilai Saat Ini" tetap dari objek sensor awal
                _buildStatRow(
                  'Nilai Saat Ini',
                  '${provider.history.last.value.toStringAsFixed(1)}${sensor.unit}',
                ),
                const Divider(height: 24),
                // Statistik lain diambil dari provider yang sudah menghitung
                _buildStatRow(
                  'Rata-rata',
                  '${provider.average.toStringAsFixed(1)}${sensor.unit}',
                ),
                const Divider(height: 24),
                _buildStatRow(
                  'Minimum',
                  '${provider.min.toStringAsFixed(1)}${sensor.unit}',
                  subtitle: 'Dalam 24 jam terakhir',
                ),
                const Divider(height: 24),
                _buildStatRow(
                  'Maksimum',
                  '${provider.max.toStringAsFixed(1)}${sensor.unit}',
                  subtitle: 'Dalam 24 jam terakhir',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget untuk membuat satu baris statistik
  Widget _buildStatRow(String label, String value, {String? subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
