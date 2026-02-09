import 'package:flutter/material.dart';
import 'features/auth/ui/screens/login/login_screen.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const Warna());
}

class Warna extends StatelessWidget {
  const Warna({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warna',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}