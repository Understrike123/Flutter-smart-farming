import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/dashboard/notification_section.dart';
import '../widgets/dashboard/sensor_grid_section.dart';
import '../widgets/dashboard/status_section.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../screens/settings_page.dart';
import 'add_device_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isFabMenuOpen = false;

  @override
  void initState() {
    super.initState();
    // Panggil provider untuk memuat semua data dasbor sekaligus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).fetchDashboardSummary();
    });
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabMenuOpen = !_isFabMenuOpen;
    });
  }

  Widget _buildFabMenu() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Color(0xFFF0F4F0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'add_sensor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddDeviceScreen(deviceType: DeviceType.sensor),
                  ),
                );
                _toggleFabMenu();
              },
              label: const Text('Sensor'),
              icon: const Icon(Icons.sensors),
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'add_actuator',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddDeviceScreen(deviceType: DeviceType.actuator),
                  ),
                );
                _toggleFabMenu();
              },
              label: const Text('Aktuator'),
              icon: const Icon(Icons.settings_remote),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        title: const Text('Dashboard Kebun Alpukat'),
        // PERBAIKAN: Pastikan actions selalu memiliki IconButton
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.dashboardSummary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = provider.dashboardSummary!;

          return RefreshIndicator(
            onRefresh: () => provider.fetchDashboardSummary(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusSection(), // Status bisa tetap statis atau diambil dari summary
                    const SizedBox(height: 20),
                    // Berikan data sensor ke widget
                    SensorGridSection(sensors: summary.sensors),
                    const SizedBox(height: 20),
                    // Berikan data notifikasi ke widget
                    NotificationSection(notifications: summary.notifications),
                    const SizedBox(height: 20),
                    const ActionButtonsSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFabMenuOpen) _buildFabMenu(),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: _toggleFabMenu,
            child: Icon(_isFabMenuOpen ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }
}
