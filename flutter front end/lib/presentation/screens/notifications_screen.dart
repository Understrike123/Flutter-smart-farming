import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification/notification_tile.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/dashboard/notification_section.dart';
import '../widgets/dashboard/sensor_grid_section.dart';
import '../widgets/dashboard/status_section.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../screens/settings_page.dart';
import '../screens/actuator_controll_screen.dart';
import 'add_device_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/shared/bottom_navbar.dart';
import 'all_sensor_screen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchNotifications();
    });
  }

  int _currentNavIndex = 0;

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
      appBar: AppBar(title: const Text('Notifikasi & Peringatan')),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterChips(provider),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filteredNotifications.isEmpty
                    ? const Center(child: Text('Tidak ada notifikasi.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              provider.filteredNotifications[index];
                          return NotificationTile(
                            notification: notification,
                            onTap: () {
                              provider.markAsRead(notification.id);
                              // TODO: Navigasi ke halaman detail jika perlu
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BotNavBarCustom(
        currentIndex: _currentNavIndex,
        onTabTapped: _handleNavTap,
      ),
    );
  }

  Widget _buildFilterChips(NotificationProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterChip(
            label: const Text('Semua'),
            selected: provider.currentFilter == NotificationFilter.semua,
            onSelected: (_) => provider.setFilter(NotificationFilter.semua),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Penting'),
            selected: provider.currentFilter == NotificationFilter.penting,
            onSelected: (_) => provider.setFilter(NotificationFilter.penting),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Belum Dibaca'),
            selected: provider.currentFilter == NotificationFilter.belumDibaca,
            onSelected: (_) =>
                provider.setFilter(NotificationFilter.belumDibaca),
          ),
        ],
      ),
    );
  }
}
