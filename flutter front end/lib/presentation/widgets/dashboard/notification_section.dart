import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/notification.dart';
import '../../providers/notification_provider.dart';
import '../../screens/notifications_screen.dart';
import '../notification/notification_tile.dart';

class NotificationSection extends StatelessWidget {
  final List<AppNotification> notifications; // Terima data dari luar

  const NotificationSection({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Ambil pratinjau 2 notifikasi teratas dari data yang diterima
    final notificationsPreview = notifications.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifikasi & Peringatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (notificationsPreview.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Tidak ada notifikasi baru'),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationsPage(),
                              ),
                            );
                          },

                          child: Text(
                            'Lihat notifikasi',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                  itemCount: notificationsPreview.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notification = notificationsPreview[index];
                    return NotificationTile(
                      notification: notification,
                      onTap: () {
                        // Saat di-tap, tandai sudah dibaca (melalui provider)
                        // dan pindah ke halaman notifikasi lengkap
                        context.read<NotificationProvider>().markAsRead(
                          notification.id,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Tampilkan tombol "Lihat Semua" jika ada lebih dari 2 notifikasi
                if (notifications.length > 2)
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
            ),
          ),
      ],
    );
  }
}
