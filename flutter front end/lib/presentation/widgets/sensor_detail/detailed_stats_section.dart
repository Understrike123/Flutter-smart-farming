import 'package:flutter/material.dart';
import 'package:flutter_smarthome/domain/entities/sensor.dart';

class DetailedStatsSection extends StatelessWidget {
  // Terima objek Sensor dari luar
  final Sensor sensor;

  const DetailedStatsSection({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            // Gunakan data dari objek sensor
            _buildStatRow('Nilai Saat Ini', '${sensor.value}${sensor.unit}'),
            const Divider(height: 24),
            _buildStatRow(
              'Rata-rata',
              '${sensor.average.toStringAsFixed(1)}${sensor.unit}',
            ),
            const Divider(height: 24),
            _buildStatRow(
              'Minimum',
              '${sensor.min.toStringAsFixed(1)}${sensor.unit}',
              subtitle: 'Dalam 24 jam terakhir',
            ),
            const Divider(height: 24),
            _buildStatRow(
              'Maksimum',
              '${sensor.max.toStringAsFixed(1)}${sensor.unit}',
              subtitle: 'Dalam 24 jam terakhir',
            ),
          ],
        ),
      ),
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
