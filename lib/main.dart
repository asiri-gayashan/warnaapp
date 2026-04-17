import 'package:flutter/material.dart';
import 'package:warna_app/router/router.dart';
import 'config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Warna());
}

class Warna extends StatelessWidget {
  const Warna({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Education Platform',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
     routerConfig: RouterClass.router,
 
    );
  }
}
