import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import untuk debugPrint
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
    final url = Uri.parse('https://depotaircerdas.com/api/sf/dashboard');
    final token = sharedPreferences.getString('authToken');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // --- TAMBAHKAN KODE DEBUG DI SINI ---
    debugPrint('--- Dashboard API Response ---');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');
    debugPrint('-----------------------------');
    // ------------------------------------
    if (response.statusCode == 200) {
      try {
        // Baris ini adalah kemungkinan sumber error
        return DashboardSummary.fromJson(json.decode(response.body)['data']);
      } catch (e) {
        // Jika parsing gagal, kita bisa melihat errornya di sini
        debugPrint('FATAL: Error parsing dashboard JSON: $e');
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }
}
