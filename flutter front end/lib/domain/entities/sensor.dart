import 'package:flutter/material.dart';

class Sensor {
  // PERBAIKAN: Ubah tipe data id dari String menjadi int
  final int id;
  final String name;
  final double value;
  final String unit;
  final String statusLabel;
  final String iconPath;
  final Color color;
  // field ini tidak ada di API dari back end
  final double average;
  final double min;
  final double max;

  Sensor({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.statusLabel,
    required this.iconPath,
    required this.color,
    this.average = 0.0,
    this.min = 0.0,
    this.max = 0.0,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    // PERBAIKAN: Tambahkan kembali fungsi helper 'toDouble' yang hilang
    String _getStatusLabel(double val) {
      if (val > 50) return "Normal";
      if (val > 20) return "Cukup";
      return "Rendah";
    }

    // Data statistik mungkin berada di dalam nested object
    double currentValue = (json['value'] as num?)?.toDouble() ?? 0.0;
    return Sensor(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Sensor Tidak Dikenal',
      // PERBAIKAN: Gunakan 'value' dari JSON, bukan 'current_value'
      value: json['value'],
      unit: json['unit'] ?? '',
      // PERBAIKAN: Buat status label secara lokal berdasarkan nilai
      statusLabel: _getStatusLabel(currentValue),
      iconPath: _getIconPathFromName(json['name']),
      color: _getColorFromName(json['name']),
      // Beri nilai default karena API /dashboard tidak menyediakannya
      average: (json['stats']?['average'] as num?)?.toDouble() ?? 0.0,
      min: (json['stats']?['min'] as num?)?.toDouble() ?? 0.0,
      max: (json['stats']?['max'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Helper untuk menentukan ikon secara lokal
  static String _getIconPathFromName(String? name) {
    switch (name?.toLowerCase()) {
      case 'kelembaban tanah':
        return 'assets/icons/plant.png';
      case 'suhu udara':
        return 'assets/icons/temperature.png';
      case 'kelembaban udara':
        return 'assets/icons/humidity.png';
      case 'intensitas cahaya':
        return 'assets/icons/sun.png';
      default:
        return 'assets/icons/sensor.png'; // Ikon default
    }
  }

  // Helper untuk menentukan warna secara lokal
  static Color _getColorFromName(String? name) {
    switch (name?.toLowerCase()) {
      case 'kelembaban tanah':
        return const Color(0xFF5E8C61);
      case 'suhu udara':
        return Colors.orange;
      case 'kelembaban udara':
        return Colors.blue;
      case 'intensitas cahaya':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
