import 'package:flutter/material.dart';

class Sensor {
  final String id;
  final String name;
  final String value;
  final String statusLabel;
  final String iconPath;
  final Color color;

  Sensor({
    required this.id,
    required this.name,
    required this.value,
    required this.statusLabel,
    required this.iconPath,
    required this.color,
  });
}
