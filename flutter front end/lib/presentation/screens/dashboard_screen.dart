import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/dashboard/notification_section.dart';
import '../widgets/dashboard/sensor_grid_section.dart';
import '../widgets/dashboard/status_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(/* ... AppBar tidak berubah ... */),
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
    );
  }
}
