import 'package:flutter/material.dart';

class Sensor {
  final String id;
  final String name;
  final String value;
  final String unit;
  final String statusLabel;
  final String iconPath;
  final Color color;

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
    required this.average,
    required this.min,
    required this.max,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    // Fungsi helper untuk mengubah nilai menjadi double dengan aman
    double toDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Data statistik mungkin berada di dalam nested object
    final stats = json['stats'] ?? {};

    return Sensor(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sensor Tidak Dikenal',
      value: json['current_value']?.toString() ?? '0',
      unit: json['unit'] ?? '',
      statusLabel: json['status'] ?? 'N/A',
      // Kita akan memetakan ikon dan warna secara lokal berdasarkan nama/tipe
      iconPath: _getIconPathFromName(json['name']),
      color: _getColorFromName(json['name']),
      average: toDouble(stats['average']),
      min: toDouble(stats['min']),
      max: toDouble(stats['max']),
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
