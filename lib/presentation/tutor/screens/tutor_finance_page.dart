import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class TutorFinancePage extends StatelessWidget {
  const TutorFinancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Finance',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Coming soon',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
