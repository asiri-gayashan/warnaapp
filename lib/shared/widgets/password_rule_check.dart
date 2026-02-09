import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PasswordRuleCheck extends StatelessWidget {
  final String rule;
  final bool isMet;

  const PasswordRuleCheck({
    Key? key,
    required this.rule,
    required this.isMet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: isMet ? AppColors.success : AppColors.textDisabled,
          ),
          const SizedBox(width: 12),
          Text(
            rule,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isMet ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}