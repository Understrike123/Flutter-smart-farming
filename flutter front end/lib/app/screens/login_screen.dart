import 'package:flutter/material.dart';
import '../../widgets/login/login_form.dart';
import '../../widgets/login/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk mendapatkan ukuran layar
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Mengubah warna background sesuai desain
      backgroundColor: const Color(0xFFF7F6F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // Memberi padding vertikal agar tidak terlalu mepet
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            // Mengatur tinggi minimal agar konten bisa di tengah secara vertikal
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                // Bagian Header: Logo dan Judul
                LoginHeader(),
                SizedBox(height: 48), // Jarak antara header dan form
                // Bagian Form: Input dan Tombol
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
