import 'package:flutter/material.dart';
import 'package:flutter_smarthome/domain/entities/sensor.dart';
import 'package:provider/provider.dart';
import 'sensor_detail_screen.dart';
import '../widgets/shared/sensor_card.dart';
import '../providers/dashboard_provider.dart';

import '../../presentation/screens/notifications_screen.dart';
import '../screens/settings_page.dart';
import '../providers/dashboard_provider.dart';
import '../screens/actuator_controll_screen.dart';
import 'add_device_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/shared/bottom_navbar.dart';
import 'all_sensor_screen.dart';

class AllSensorScreen extends StatefulWidget {
  final List<Sensor> sensors; // Terima data dari luar

  const AllSensorScreen({super.key, required this.sensors});

  State<AllSensorScreen> createState() => _AllSensorScreenState();
}

class _AllSensorScreenState extends State<AllSensorScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Panggil provider untuk memuat semua data dasbor sekaligus
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<DashboardProvider>(
  //       context,
  //       listen: false,
  //     ).fetchDashboardSummary();
  //   });
  // }

  int _currentNavIndex = 1;

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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Sensor')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: widget.sensors.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final sensor = widget.sensors[index];
                // ignore: non_constant_identifier_names
                return SensorCard(
                  iconPath: sensor.iconPath,
                  value: sensor.value,
                  unit: sensor.unit,
                  label: sensor.statusLabel,
                  iconColor: sensor.color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Kirim objek sensor lengkap ke halaman detail
                        builder: (context) =>
                            SensorDetailScreen(sensor: sensor),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BotNavBarCustom(
        currentIndex: _currentNavIndex,
        onTabTapped: _handleNavTap,
      ),
    );
  }
}
