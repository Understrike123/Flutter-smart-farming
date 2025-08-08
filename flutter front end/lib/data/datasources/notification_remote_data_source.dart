import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/error_exceptions.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotification>> getNotifications(String filter);
  Future<void> markAsRead(int notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<List<AppNotification>> getNotifications(String filter) async {
    // Bangun URL dengan query parameter untuk filter
    final url = Uri.parse(
      'http://localhost:8080/api/v1/notifications?filter=$filter',
    );
    final token = sharedPreferences.getString('authToken');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => AppNotification.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    final url = Uri.parse(
      'http://localhost:8080/api/v1/notifications/$notificationId/read',
    );
    final token = sharedPreferences.getString('authToken');

    final response = await client.put(
      // Gunakan metode PUT sesuai spesifikasi
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
