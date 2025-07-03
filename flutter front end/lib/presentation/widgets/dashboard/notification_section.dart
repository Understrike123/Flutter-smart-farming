import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/notifications_screen.dart';
import '../../providers/notification_provider.dart';
import '../notification/notification_tile.dart';

// 1. Ubah menjadi StatefulWidget untuk memuat data saat pertama kali muncul
class NotificationSection extends StatefulWidget {
  const NotificationSection({super.key});

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  @override
  void initState() {
    super.initState();
    // 2. Minta Provider untuk memuat data saat widget ini pertama kali dibuat
    // Ini memastikan data selalu segar saat pengguna membuka dasbor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifikasi & Peringatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // 3. Gunakan Consumer untuk mendengarkan perubahan dari NotificationProvider
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            // Tampilkan loading indicator saat data sedang diambil
            if (provider.isLoading && provider.filteredNotifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Ambil hanya 2 notifikasi teratas untuk ditampilkan di dasbor
            final notificationsPreview = provider.filteredNotifications
                .take(2)
                .toList();

            if (notificationsPreview.isEmpty) {
              return const Card(
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text('Tidak ada notifikasi baru'),
                ),
              );
            }

            // 4. Tampilkan daftar notifikasi menggunakan widget NotificationTile yang baru
            return Column(
              children: [
                ...notificationsPreview.map((notification) {
                  return NotificationTile(
                    notification: notification,
                    onTap: () {
                      // Saat di-tap, tandai sudah dibaca dan pindah ke halaman notifikasi
                      provider.markAsRead(notification.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  );
                }).toList(),
                // Tambahkan tombol "Lihat Semua" jika ada lebih dari 2 notifikasi
                if (provider.filteredNotifications.length > 2)
                  ListTile(
                    title: Text(
                      'Lihat Semua Notifikasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
