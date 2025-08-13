import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // Untuk parsing JSON contoh

// --- Model Data (sesuaikan dengan path model Anda) ---
class SettingThreshold {
  final int id;
  final String name;
  int thresholdMin;
  int thresholdMax;

  SettingThreshold({
    required this.id,
    required this.name,
    required this.thresholdMin,
    required this.thresholdMax,
  });

  factory SettingThreshold.fromJson(Map<String, dynamic> json) {
    return SettingThreshold(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      thresholdMin: json['threshold_min'] ?? 0,
      thresholdMax: json['threshold_max'] ?? 100,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'threshold_min': thresholdMin,
      'threshold_max': thresholdMax,
    };
  }
}
