import 'package:flutter/material.dart';
import '../../widgets/shared/notification_tile.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key});

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
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              NotificationTile(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                title: 'Kelembaban Tanah Rendah!',
                subtitle: '(Zona 2) – Diperlukan Penyiraman',
                onTap: () {},
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              NotificationTile(
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                title: 'Jadwal Irigasi Otomatis',
                subtitle: '(Zona 1) telah selesai',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
