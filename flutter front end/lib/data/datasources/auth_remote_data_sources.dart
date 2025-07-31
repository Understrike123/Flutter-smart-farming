import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_smarthome/data/repositories/data_failure_repository.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/error_exceptions.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourcesImpl({required this.client});

  @override
  Future<User> login(String email, String password) async {
    // url login
    final url = Uri.parse('http://localhost:8080/api/v1/auth/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);

        final user = User.fromJson(responseData);
        return User(
          id: user.id,
          name: user.name,
          email: email,
          token: user.token,
        );
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
