import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/actuator_provider.dart';
import '../widgets/actuator_controll/actuator_card.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/dashboard/notification_section.dart';
import '../widgets/dashboard/sensor_grid_section.dart';
import '../widgets/dashboard/status_section.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../screens/settings_page.dart';
import '../providers/dashboard_provider.dart';
import '../screens/actuator_controll_screen.dart';
import 'add_device_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/shared/bottom_navbar.dart';
import 'all_sensor_screen.dart';

class ActuatorControlScreen extends StatefulWidget {
  const ActuatorControlScreen({super.key});

  @override
  State<ActuatorControlScreen> createState() => _ActuatorControlScreenState();
}

class _ActuatorControlScreenState extends State<ActuatorControlScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActuatorProvider>(context, listen: false).fetchActuators();
    });
  }

  int _currentNavIndex = 2;

  void _handleNavTap(int index) {
    // Jika pengguna menekan tab yang sudah aktif, jangan lakukan apa-apa
    if (index == _currentNavIndex) return;

    // PERBAIKAN 1: Ambil instance provider secara manual di dalam fungsi
    final provider = Provider.of<DashboardProvider>(context, listen: false);

    // PERBAIKAN 2: Pastikan data summary tidak null sebelum digunakan
    if (provider.dashboardSummary == null) {
      // Jika data belum siap, jangan lakukan navigasi dan beri tahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data sedang dimuat, coba sesaat lagi.')),
      );
      return;
    }

    final summary = provider.dashboardSummary!;
    setState(() => _currentNavIndex = index);

    // Navigasi manual dengan push/pushReplacement
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AllSensorScreen(sensors: summary.sensors),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ActuatorControlScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NotificationsPage()),
      );
    }
    // ... dan seterusnya untuk halaman lainnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: const Text('Kontrol Aktuator')),
      body: Consumer<ActuatorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.actuators.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchActuators(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.actuators.length,
              itemBuilder: (context, index) {
                final actuator = provider.actuators[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ActuatorCard(
                    key: ValueKey(actuator.id),
                    actuatorData: actuator,
                    isUpdating: provider.isUpdating(actuator.id),
                    onStatusCommand: (command) {
                      provider.sendCommand(actuator.id, command);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BotNavBarCustom(
        currentIndex: _currentNavIndex,
        onTabTapped: _handleNavTap,
      ),
    );
  }
}
