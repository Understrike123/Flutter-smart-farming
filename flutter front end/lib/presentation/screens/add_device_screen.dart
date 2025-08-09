import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart'; // Kita akan tambahkan method baru di sini

enum DeviceType { sensor, actuator }

class AddDeviceScreen extends StatefulWidget {
  final DeviceType deviceType;
  const AddDeviceScreen({super.key, required this.deviceType});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _unitController = TextEditingController(); // Khusus untuk sensor

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    _typeController.dispose();
    _locationController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": _nameController.text,
        "device_id": _deviceIdController.text,
        "type": _typeController.text,
        "location": _locationController.text,
        if (widget.deviceType == DeviceType.sensor)
          "unit": _unitController.text,
      };

      final provider = context.read<DashboardProvider>();

      // Panggil method provider yang sesuai
      (widget.deviceType == DeviceType.sensor
              ? provider.addSensor(data)
              : provider.addActuator(data))
          .then((success) {
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${widget.deviceType.name} berhasil ditambahkan!',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menambahkan ${widget.deviceType.name}.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final title = widget.deviceType == DeviceType.sensor
        ? 'Tambah Sensor Baru'
        : 'Tambah Aktuator Baru';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Perangkat'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _deviceIdController,
              decoration: const InputDecoration(
                labelText: 'ID Perangkat (dari hardware)',
              ),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Tipe'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokasi'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            if (widget.deviceType == DeviceType.sensor)
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Unit (misal: °C, %)',
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: provider.isAddingDevice ? null : _submitForm,
              child: provider.isAddingDevice
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan Perangkat'),
            ),
          ],
        ),
      ),
    );
  }
}
