import 'package:flutter/material.dart';

class SensorSelector extends StatefulWidget {
  const SensorSelector({super.key});

  @override
  State<SensorSelector> createState() => _SensorSelectorState();
}

class _SensorSelectorState extends State<SensorSelector> {
  // Data dummy untuk pilihan sensor
  final List<String> _sensorOptions = [
    'Kelembaban Tanah Zona 1',
    'Kelembaban Tanah Zona 2',
    'Suhu Udara',
    'Kelembaban Udara',
    'Intensitas Cahaya',
  ];
  String? _selectedSensor;

  @override
  void initState() {
    super.initState();
    // Atur nilai default saat widget pertama kali dibuat
    _selectedSensor = _sensorOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Sensor:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSensor,
          items: _sensorOptions.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedSensor = newValue;
              // TODO: Tambahkan logika untuk memuat data baru berdasarkan sensor yang dipilih
            });
          },
          decoration: InputDecoration(
            // Menggunakan gaya dari theme yang sudah kita definisikan
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
