import 'package:flutter/material.dart';

class DetailedStatsSection extends StatelessWidget {
  const DetailedStatsSection({super.key});

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
            _buildStatRow('Nilai Saat Ini', '68%'),
            const Divider(height: 24),
            _buildStatRow('Rata-rata', '62%'),
            const Divider(height: 24),
            _buildStatRow('Minimum', '35%', subtitle: 'Kemarin, 14.30 WIB'),
            const Divider(height: 24),
            _buildStatRow('Maksimum', '80%', subtitle: '(Hari Ini, 07.00 WIB)'),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat satu baris statistik agar tidak duplikasi kode
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
