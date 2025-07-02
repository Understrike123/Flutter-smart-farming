import 'package:flutter/material.dart';

// Enum untuk merepresentasikan status aktuator
enum ActuatorStatus { aktif, nonaktif }

class ActuatorCard extends StatefulWidget {
  final String title;
  final String iconPath;
  final bool hasAdvancedControls;

  const ActuatorCard({
    super.key,
    required this.title,
    this.iconPath = '',
    this.hasAdvancedControls = false,
  });

  @override
  State<ActuatorCard> createState() => _ActuatorCardState();
}

// PERUBAHAN 1: Tambahkan 'with AutomaticKeepAliveClientMixin'
class _ActuatorCardState extends State<ActuatorCard>
    with AutomaticKeepAliveClientMixin {
  ActuatorStatus _status = ActuatorStatus.nonaktif;
  String _mode = "OTOMATIS";

  final TextEditingController _durationController = TextEditingController(
    text: '30',
  );

  // PERUBAHAN 2: Tambahkan getter 'wantKeepAlive'
  // Ini memberitahu Flutter untuk menjaga state widget ini tetap hidup.
  @override
  bool get wantKeepAlive => true;

  void _setStatus(ActuatorStatus newStatus) {
    setState(() {
      _status = newStatus;
      _mode = (newStatus == ActuatorStatus.aktif) ? "MANUAL" : "OTOMATIS";
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // PERUBAHAN 3: Panggil super.build(context)
    // Ini wajib saat menggunakan AutomaticKeepAliveClientMixin.
    super.build(context);

    final bool isAktif = _status == ActuatorStatus.aktif;
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
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Status:',
              _status.name.toUpperCase(),
              color: isAktif ? primaryColor : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Mode:', _mode),
            const SizedBox(height: 16),
            _buildActionButtons(),
            if (widget.hasAdvancedControls) ...[
              const SizedBox(height: 16),
              _buildAdvancedControls(),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: widget.iconPath.isNotEmpty
                ? Image.asset(widget.iconPath, color: Colors.white, height: 20)
                : const Icon(Icons.power_settings_new, size: 20),
            label: const Text('AKTIFKAN'),
            onPressed: () => _setStatus(ActuatorStatus.aktif),
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
            onPressed: () => _setStatus(ActuatorStatus.nonaktif),
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

  Widget _buildAdvancedControls() {
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
