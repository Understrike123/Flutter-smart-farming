import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/error_exceptions.dart';
import '../../domain/entities/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
}

class AuthRemoteDataSourcesImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourcesImpl({required this.client, required this.baseUrl});

  @override
  Future<User> login(String username, String password) async {
    // final baseUrl = dotenv.env['API_BASE_URL'];
    // url login
    final url = Uri.parse('${baseUrl}api/auth/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Asumsikan respons berisi field 'token' dan 'username' sesuai server.js
      // Kita perlu membuat objek User dari data ini.
      return User(
        id: responseData['user']?['id']?.toString() ?? '0',
        name: responseData['name'] ?? '',
        depotName: responseData['depot_name'] ?? '',
        username:
            responseData['username'] ??
            '', // Ambil dari input karena tidak ada di respons
        token: responseData['token'] ?? '',
        isSuperAdmin: responseData['is_super_admin'] == 1,
      );
    } else {
      throw ServerException();
    }
  }
}
