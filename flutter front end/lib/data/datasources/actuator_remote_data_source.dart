import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/error_exceptions.dart';
import '../../domain/entities/actuator.dart';

abstract class ActuatorRemoteDataSource {
  Future<List<Actuator>> getActuators();
  Future<void> postCommand(int actuatorId, String command);
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

    final response = await client.get(
      url,
      headers: {'Autorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => Actuator.fromJson(json)).toList();
    } else {
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
}
