import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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
          create: (context) {
            final repo = NotificationRepositoryImpl();
            return NotificationProvider(
              getNotifications: GetNotifications(repo),
              markNotificationAsRead: MarkNotificationAsRead(repo),
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
