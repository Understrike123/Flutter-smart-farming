import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ganti Icon dengan gambar logo Anda dari assets
        // Contoh: Image.asset('assets/logo/avocado_logo.png', height: 80)
        Icon(
          Icons.eco, // Placeholder icon, ganti dengan logo Anda
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 16),
        const Text(
          'Smart Farming',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
