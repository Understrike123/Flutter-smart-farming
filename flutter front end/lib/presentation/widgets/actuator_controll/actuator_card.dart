import 'package:flutter/material.dart';
import '../../../domain/entities/actuator.dart'; // Import model dari domain

// 1. Widget ini sekarang bisa menjadi StatelessWidget karena tidak lagi menyimpan state.
class ActuatorCard extends StatelessWidget {
  // 2. Ia menerima data lengkap dan sebuah fungsi dari induknya.
  final Actuator actuatorData;
  final Function(ActuatorStatus) onStatusChanged;

  const ActuatorCard({
    super.key,
    required this.actuatorData,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 3. Semua data sekarang diambil dari 'actuatorData'.
    final bool isAktif = actuatorData.status == ActuatorStatus.aktif;
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actuatorData.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Status:',
              actuatorData.status.name.toUpperCase(),
              color: isAktif ? primaryColor : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Mode:', actuatorData.mode),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            if (actuatorData.hasAdvancedControls) ...[
              const SizedBox(height: 16),
              // Widget untuk kontrol lanjutan tetap stateful secara internal
              _AdvancedControls(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: actuatorData.iconPath.isNotEmpty
                ? Image.asset(
                    actuatorData.iconPath,
                    color: Colors.white,
                    height: 20,
                  )
                : const Icon(Icons.power_settings_new, size: 20),
            label: const Text('AKTIFKAN'),
            // 4. Saat ditekan, ia memanggil fungsi 'onStatusChanged' dari induknya.
            onPressed: () => onStatusChanged(ActuatorStatus.aktif),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.cancel_outlined, size: 20),
            label: const Text('NONAKTIFKAN'),
            onPressed: () => onStatusChanged(ActuatorStatus.nonaktif),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget stateful kecil ini hanya untuk mengelola state internalnya sendiri (TextEditingController)
// dan tidak mengganggu arsitektur utama.
class _AdvancedControls extends StatefulWidget {
  @override
  _AdvancedControlsState createState() => _AdvancedControlsState();
}

class _AdvancedControlsState extends State<_AdvancedControls> {
  final TextEditingController _durationController = TextEditingController(
    text: '30',
  );

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Durasi (menit):'),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(onPressed: () {}, child: const Text('Atur Durasi')),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Jadwal Otomatis Aktif:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text('- Setiap hari pukul 06:00 (jika tanah kering)'),
        const SizedBox(height: 4),
        const Text('- Setiap sore pukul 17:00 (jika tanah kering)'),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text('Edit Jadwal')),
        ),
      ],
    );
  }
}
