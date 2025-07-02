import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Ubah import ke LoginScreen
import '/app/screens/login_screen.dart';
import '/app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SmartFarmingApp());
}

class SmartFarmingApp extends StatelessWidget {
  const SmartFarmingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming Dashboard',
      theme: AppTheme.lightTheme,
      // Ganti home ke LoginScreen untuk menampilkan halaman login
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
