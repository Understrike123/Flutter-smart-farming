import 'package:flutter/material.dart';
import 'package:flutter_smarthome/domain/entities/setting_threshold.dart';
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
  // Controller untuk text field email
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Muat data awal dan set nilai awal untuk controller
      final provider = Provider.of<SettingsProvider>(context, listen: false);
      provider.loadSettings().then((_) {
        if (provider.settings != null) {
          _emailController.text =
              provider.settings!.notificationPref.email ?? '';
        }
      });
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
  void dispose() {
    _emailController.dispose();
    super.dispose();
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

          // final settings = provider.settings!;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildSectionTitle('Pengaturan Batas Ambang'),
                    ...provider.settings!.thresholds.map((threshold) {
                      return _buildThresholdEditor(context, threshold);
                    }).toList(),

                    const Divider(height: 32),
                    _buildSectionTitle('Pengaturan Notifikasi'),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Notifikasi',
                        hintText: 'Masukkan email Anda',
                      ),
                      onChanged: (value) {
                        provider.updateLocalEmail(value);
                      },
                    ),
                    const Divider(height: 32),
                    _buildSectionTitle('Manajemen Akun'),
                    // ... (UI untuk manajemen akun tidak berubah) ...
                  ],
                ),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: provider.isSaving
                      ? null
                      : () async {
                          final success = await provider.saveSettings();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Pengaturan berhasil disimpan!'
                                      : 'Gagal menyimpan pengaturan.',
                                ),
                                backgroundColor: success
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          }
                        },
                  child: provider.isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text('Simpan Semua Pengaturan'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget baru untuk membuat editor threshold
  Widget _buildThresholdEditor(
    BuildContext context,
    SettingThreshold threshold,
  ) {
    final provider = context.read<SettingsProvider>();

    // PERBAIKAN: Tentukan rentang min/max secara dinamis berdasarkan nama sensor
    double maxSliderValue;
    int divisions;

    if (threshold.name.toLowerCase().contains('cahaya')) {
      maxSliderValue = 20000;
      divisions = 200;
    } else {
      maxSliderValue = 100;
      divisions = 100;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              threshold.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Batas Minimum: ${threshold.thresholdMin}'),
            Slider(
              value: threshold.thresholdMin.toDouble(),
              min: 0,
              max: maxSliderValue, // Gunakan nilai max dinamis
              divisions: divisions,
              label: threshold.thresholdMin.toString(),
              onChanged: (value) {
                provider.updateLocalThreshold(threshold.id, min: value.round());
              },
            ),
            const SizedBox(height: 8),
            Text('Batas Maksimum: ${threshold.thresholdMax}'),
            Slider(
              value: threshold.thresholdMax.toDouble(),
              min: 0,
              max: maxSliderValue, // Gunakan nilai max dinamis
              divisions: divisions,
              label: threshold.thresholdMax.toString(),
              onChanged: (value) {
                provider.updateLocalThreshold(threshold.id, max: value.round());
              },
            ),
          ],
        ),
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
