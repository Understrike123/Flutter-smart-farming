import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smarthome/data/datasources/auth_local_data.dart';
import 'package:flutter_smarthome/data/datasources/sensor_remote_data_source.dart';
import 'package:flutter_smarthome/data/repositories/auth_repository_impl.dart';
import 'package:flutter_smarthome/domain/usecases/login_user.dart';
import 'package:flutter_smarthome/domain/usecases/logout_user.dart';
import 'package:flutter_smarthome/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/actuator_provider.dart'; // <-- Jangan lupa import provider
import 'package:intl/date_symbol_data_local.dart';
// Import dari lokasi baru sesuai Clean Architecture
import 'data/repositories/actuator_repository_impl.dart';
import 'presentation/providers/actuator_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/theme/app_theme.dart';
import '/data/repositories/notification_repository_impl.dart';
import '/domain/usecases/get_notifications.dart';
import '/domain/usecases/mark_notification_as_read.dart';
import '/presentation/providers/notification_provider.dart';
import 'data/repositories/sensor_repository_impl.dart';
import 'domain/usecases/get_sensor_history.dart';
import 'package:flutter_smarthome/domain/usecases/get_sensor.dart';
import 'presentation/providers/sensor_provider.dart';

import 'data/repositories/settings_repository_impl.dart';
import 'domain/usecases/get_settings.dart';
import 'domain/usecases/update_settings.dart';
import 'presentation/providers/settings_provider.dart';
import 'domain/usecases/logout_user.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/auth_remote_data_sources.dart';
import 'data/repositories/sensor_repository_impl.dart';
import 'data/datasources/sensor_remote_data_source.dart';

import 'data/datasources/dashboard_remote_data_source.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/usecases/get_dashboard_summary.dart';
import 'presentation/providers/dashboard_provider.dart';

import 'data/datasources/actuator_remote_data_source.dart';
import 'data/repositories/actuator_repository_impl.dart';
import 'domain/usecases/get_actuators.dart';
import 'domain/usecases/post_actuator_command.dart';
import 'data/datasources/notification_remote_data_source.dart';
import 'data/datasources/settings_remote_data_source.dart';

import 'domain/usecases/create_sensor.dart';
import 'domain/usecases/create_actuator.dart';
import 'data/datasources/sensor_remote_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // siapkan SharedPreferences atau local storage jika perlu
  // final preferences = await SharedPreferences.getInstance();

  final prefs = await SharedPreferences.getInstance();
  // Set orientasi layar ke portrait saja
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // 1. Bungkus aplikasi dengan ChangeNotifierProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = ActuatorRemoteDataSourceImpl(
              client: http.Client(),
              sharedPreferences: prefs,
            );
            final actuatorRepo = ActuatorRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return ActuatorProvider(
              getActuators: GetActuators(actuatorRepo),
              postActuatorCommand: PostActuatorCommand(actuatorRepo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            // Buat instance dari semua dependensi
            final localDataSource = AuthLocalDataImpl(sharedPreferences: prefs);
            final remoteDataSource = AuthRemoteDataSourcesImpl(
              client: http.Client(),
            );
            final authRepo = AuthRepositoryImpl(
              localDataSource: localDataSource,
              remoteDataSource: remoteDataSource,
            );

            return AuthProvider(
              loginUser: LoginUser(authRepo),
              logoutUser: LogoutUser(authRepo), // Suntikkan use case logout
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            // Rangkai semua dependensi untuk notifikasi
            final remoteDataSource = NotificationRemoteDataSourceImpl(
              client: http.Client(),
              sharedPreferences: prefs,
            );
            final repo = NotificationRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );

            return NotificationProvider(
              getNotifications: GetNotifications(repo),
              markNotificationAsRead: MarkNotificationAsRead(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = SensorRemoteDataSourceImpl(
              client: http.Client(),
              sharedPreferences: prefs,
            );
            final sensorRepo = SensorRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return SensorProvider(
              getSensors: GetSensor(sensorRepo),
              getSensorHistory: GetSensorHistory(sensorRepo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = SettingsRemoteDataSourceImpl(
              client: http.Client(),
              sharedPreferences: prefs,
            );
            final repo = SettingsRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            return SettingsProvider(
              getSettings: GetSettings(repo),
              updateSettings: UpdateSettings(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final remoteDataSource = DashboardRemoteDataSourceImpl(
              client: http.Client(),
              sharedPreferences: prefs,
            );
            final dashboardRepo = DashboardRepositoryImpl(
              remoteDataSource: remoteDataSource,
            );
            final sensorRepo = SensorRepositoryImpl(
              remoteDataSource: SensorRemoteDataSourceImpl(
                client: http.Client(),
                sharedPreferences: prefs,
              ),
            );
            final actuatorRepo = ActuatorRepositoryImpl(
              remoteDataSource: ActuatorRemoteDataSourceImpl(
                client: http.Client(),
                sharedPreferences: prefs,
              ),
            );
            return DashboardProvider(
              getDashboardSummary: GetDashboardSummary(dashboardRepo),
              createSensor: CreateSensor(
                sensorRepo,
              ), // <-- Suntikkan use case baru
              createActuator: CreateActuator(
                actuatorRepo,
              ), // <-- Suntikkan use case baru
            );
          },
        ),
      ],
      child: const SmartFarmingApp(),
    ),
  );
}

class SmartFarmingApp extends StatelessWidget {
  const SmartFarmingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming Dashboard',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
