import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).loadSettings();
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // 1. Panggil method logout dari provider
                await authProvider.logout();

                // 2. Cek apakah widget masih ada di pohon widget sebelum navigasi
                if (mounted) {
                  // 3. Navigasi ke halaman login dan hapus semua halaman sebelumnya
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = provider.settings!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle('Notifikasi'),
              SwitchListTile(
                title: const Text('Aktifkan Notifikasi'),
                subtitle: const Text(
                  'Terima peringatan penting dari kebun Anda.',
                ),
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  provider.updateNotificationSetting(value);
                },
              ),
              const Divider(),
              _buildSectionTitle('Ambang Batas Sensor'),
              ListTile(
                title: const Text('Kelembaban Tanah Minimum'),
                subtitle: Text(
                  'Notifikasi akan dikirim jika di bawah ${settings.soilMoistureThreshold.toStringAsFixed(0)}%',
                ),
              ),
              Slider(
                value: settings.soilMoistureThreshold,
                min: 10,
                max: 50,
                divisions: 40, // Dibuat lebih halus
                label: '${settings.soilMoistureThreshold.toStringAsFixed(0)}%',
                onChanged: (value) {
                  // Panggil update saat slider selesai digeser
                  provider.updateThresholdSetting(value);
                },
              ),
              const Divider(),
              _buildSectionTitle('Akun'),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profil'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  /* TODO: Navigasi ke halaman edit profil */
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Ubah Kata Sandi'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  /* TODO: Navigasi ke halaman ubah kata sandi */
                },
              ),
              // BAGIAN YANG DIPERBARUI
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: Text(
                  'Keluar', // Mengganti 'Sign Out' agar konsisten
                  style: TextStyle(color: Colors.red.shade700),
                ),
                onTap: () {
                  // Panggil dialog konfirmasi saat tombol di-tap
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
