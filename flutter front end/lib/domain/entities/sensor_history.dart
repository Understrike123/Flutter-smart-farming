class SensorHistory {
  final DateTime timestamp;
  final double value;

  SensorHistory({required this.timestamp, required this.value});

  factory SensorHistory.fromJson(Map<String, dynamic> json) {
    return SensorHistory(
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
