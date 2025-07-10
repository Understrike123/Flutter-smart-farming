import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smarthome/data/datasources/auth_local_data.dart';
import 'package:flutter_smarthome/data/repositories/auth_repository_impl.dart';
import 'package:flutter_smarthome/domain/usecases/login_user.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // siapkan SharedPreferences atau local storage jika perlu
  final preferences = await SharedPreferences.getInstance();

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
          create: (context) => ActuatorProvider(ActuatorRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            loginUser: LoginUser(
              AuthRepositoryImpl(
                localDataSource: AuthLocalDataImpl(
                  sharedPreferences: preferences,
                ),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final repo = NotificationRepositoryImpl();
            return NotificationProvider(
              getNotifications: GetNotifications(repo),
              markNotificationAsRead: MarkNotificationAsRead(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final repo = SensorRepositoryImpl();
            return SensorProvider(
              getSensors: GetSensor(repo),
              getSensorHistory: GetSensorHistory(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final repo = SettingsRepositoryImpl(sharedPreferences: prefs);
            return SettingsProvider(
              getSettings: GetSettings(repo),
              updateSettings: UpdateSettings(repo),
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
