import 'package:flutter/material.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/dashboard/notification_section.dart';
import '../widgets/dashboard/sensor_grid_section.dart';
import '../widgets/dashboard/status_section.dart';
import 'notifications_screen.dart';
import '../screens/settings_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusSection(),
              SizedBox(height: 20),
              SensorGridSection(),
              SizedBox(height: 20),
              NotificationSection(),
              SizedBox(height: 20),
              ActionButtonsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
