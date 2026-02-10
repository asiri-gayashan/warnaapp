import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/registration_strings.dart';
import '../../../logic/registration_controller.dart';

class RegistrationStep5 extends StatelessWidget {
  final RegistrationController controller;
  final VoidCallback onComplete;

  const RegistrationStep5({
    Key? key,
    required this.controller,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 60,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          _getTitle(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Message
        Text(
          _getMessage(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        // Dashboard Button
        CustomButton(
          text: RegistrationStrings.goToDashboard,
          onPressed: () {
            // Navigate to student dashboard
            Navigator.pushReplacementNamed(context, '/student');
          },
          hasShadow: true,
          backgroundColor: AppColors.success,
        ),
      ],
    );
  }

  String _getTitle() {
    switch (controller.selectedRole) {
      case UserRole.instituteAdmin:
        return RegistrationStrings.step5TitleAdmin;
      case UserRole.teacher:
        return RegistrationStrings.step5TitleTeacher;
      case UserRole.student:
        return RegistrationStrings.step5TitleStudent;
      default:
        return '🎉 Registration Complete!';
    }
  }

  String _getMessage() {
    switch (controller.selectedRole) {
      case UserRole.instituteAdmin:
        return RegistrationStrings.step5MessageAdmin;
      case UserRole.teacher:
        return RegistrationStrings.step5MessageTeacher;
      case UserRole.student:
        return RegistrationStrings.step5MessageStudent;
      default:
        return 'Your account is ready to use.';
    }
  }
}