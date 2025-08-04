import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/error_exceptions.dart';
import '../../domain/entities/dashboard_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummary> getDashboardSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  DashboardRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    final url = Uri.parse('http://localhost:8080/api/v1/dashboard');
    final token = sharedPreferences.getString('authToken');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return DashboardSummary.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException();
    }
  }
}
