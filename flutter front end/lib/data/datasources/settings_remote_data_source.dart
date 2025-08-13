import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/entities/setting_threshold.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsRemoteDataSource {
  Future<AppSettings> getSettings();
  Future<void> updateSettings(AppSettings settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl;

  SettingsRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
    required this.baseUrl,
  });

  @override
  Future<AppSettings> getSettings() async {
    final url = Uri.parse('${baseUrl}api/sf/settings');
    final token = sharedPreferences.getString('authToken');

    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return AppSettings.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateSettings(AppSettings settings) async {
    final url = Uri.parse('${baseUrl}api/sf/settings');
    final token = sharedPreferences.getString('authToken');

    final body = {
      'new_thresholds': settings.thresholds.map((t) => t.toJson()).toList(),
      'new_email': settings.notificationPref.email,
    };
    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
