import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smarthome/presentation/providers/auth_provider.dart';
import '../../screens/dashboard_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _listenToAuthState(BuildContext context, AuthProvider provider) {
    if (provider.state == AuthState.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      // reset state setelah navigasi
      provider.resetState();
    } else if (provider.state == AuthState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      // reset state setelah menampilkan error
      provider.resetState();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state dari AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToAuthState(context, authProvider);
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input untuk Email atau Username
          const Text(
            'Email atau Username',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Masukkan email atau username Anda',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty
                ? 'Email atau username tidak boleh kosong'
                : null, // Validasi input tidak boleh kosong
          ),
          const SizedBox(height: 20),

          // Input untuk Kata Sandi
          const Text(
            'Kata Sandi',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: true, // Untuk menyembunyikan teks kata sandi
            decoration: const InputDecoration(
              hintText: 'Masukkan kata sandi Anda',
            ),
            validator: (value) => value!.isEmpty
                ? 'Kata sandi tidak boleh kosong'
                : null, // Validasi input tidak boleh kosong
          ),
          const SizedBox(height: 32),

          // Tombol Masuk
          ElevatedButton(
            onPressed: authProvider.state == AuthState.loading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthProvider>().login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: authProvider.state == AuthState.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('Masuk'),
          ),
          const SizedBox(height: 24),

          // Tombol Lupa Kata Sandi
          TextButton(
            onPressed: () {},
            child: Text(
              'Lupa Kata Sandi?',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 24),

          // Teks dan Tombol Daftar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun? ',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  'Daftar di Sini',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
