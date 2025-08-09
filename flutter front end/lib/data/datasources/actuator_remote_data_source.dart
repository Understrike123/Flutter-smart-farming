import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/error_exceptions.dart';
import '../../domain/entities/actuator.dart';

abstract class ActuatorRemoteDataSource {
  Future<List<Actuator>> getActuators();
  Future<void> postCommand(int actuatorId, String command);
  Future<void> createActuator(Map<String, dynamic> actuatorData);
}

class ActuatorRemoteDataSourceImpl implements ActuatorRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  ActuatorRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<List<Actuator>> getActuators() async {
    final url = Uri.parse('http://localhost:8080/api/v1/actuators');
    final token = sharedPreferences.getString('authToken');
    debugPrint(
      "DATA SOURCE: Mengirim GET request ke $url dengan token: Bearer $token",
    );

    try {
      final response = await client.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      // --- LOG 4: Lihat respons dari server ---
      debugPrint(
        "DATA SOURCE: Menerima respons - Status: ${response.statusCode}, Body: ${response.body}",
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Actuator.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      // --- LOG 5: Tangkap error jika ada masalah jaringan ---
      debugPrint("DATA SOURCE: Terjadi error saat request: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> postCommand(int actuatorId, String command) async {
    final url = Uri.parse(
      'http://localhost:8080/api/v1/actuators/$actuatorId/command',
    );
    final token = sharedPreferences.getString('authToken');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'command': command}),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> createActuator(Map<String, dynamic> actuatorData) async {
    final url = Uri.parse('http://localhost:8080/api/v1/actuators');
    final token = sharedPreferences.getString('authToken');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(actuatorData),
    );

    if (response.statusCode != 201) {
      // 201 Created
      throw ServerException();
    }
  }
}
