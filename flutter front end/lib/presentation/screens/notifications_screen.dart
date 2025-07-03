import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification/notification_tile.dart';

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
