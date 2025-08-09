import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/entities/sensor.dart';
import 'package:flutter/foundation.dart';

abstract class SensorRemoteDataSource {
  Future<List<Sensor>> getSensors();
  Future<void> createSensor(Map<String, dynamic> sensorData);
}

class SensorRemoteDataSourceImpl implements SensorRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  SensorRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<List<Sensor>> getSensors() async {
    final url = Uri.parse('http://localhost:8080/api/v1/sensors');
    final token = sharedPreferences.getString('authToken');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> sensorJsonList = json.decode(response.body);
      return sensorJsonList.map((json) => Sensor.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createSensor(Map<String, dynamic> sensorData) async {
    final url = Uri.parse('http://localhost:8080/api/v1/sensors');
    final token = sharedPreferences.getString('authToken');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(sensorData),
    );

    if (response.statusCode != 201) {
      // 201 Created
      throw ServerException();
    }
  }
}
