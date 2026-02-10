import 'package:flutter/material.dart';
import './features/auth/ui/screens/login/login_screen.dart';
import './features/auth/ui/screens/registration/registration_screen.dart';
import 'config/theme/app_theme.dart';import 'features/student/ui/navigation/student_navigation.dart';


void main() {
  runApp(const Warna());
}

class Warna extends StatelessWidget {
  const Warna({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education Platform',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/student': (context) => const StudentNavigation(),
      },
    );
  }
}