import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/entities/sensor.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/sensor_history.dart';

abstract class SensorRemoteDataSource {
  Future<List<Sensor>> getSensors();
  Future<List<SensorHistory>> getSensorHistory(int sensorId);
  Future<void> createSensor(Map<String, dynamic> sensorData);
}

class SensorRemoteDataSourceImpl implements SensorRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl;

  SensorRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
    required this.baseUrl,
  });

  @override
  Future<List<Sensor>> getSensors() async {
    // ignore: unnecessary_brace_in_string_interps
    final url = Uri.parse('${baseUrl}/api/sf/sensors');
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
    final url = Uri.parse('${baseUrl}api/sf/sensors');
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

  @override
  Future<List<SensorHistory>> getSensorHistory(int sensorId) async {
    final url = Uri.parse(
      '${baseUrl}api/sf/sensors/$sensorId/history?duration=30d',
    );
    final token = sharedPreferences.getString('authToken');

    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => SensorHistory.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
