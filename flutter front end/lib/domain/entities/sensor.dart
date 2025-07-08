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
}
