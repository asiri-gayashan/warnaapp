import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../shared/widgets/password_rule_check.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/registration_strings.dart';
import '../../../logic/registration_controller.dart';

class RegistrationStep2 extends StatefulWidget {
  final RegistrationController controller;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegistrationStep2({
    Key? key,
    required this.controller,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 25),


          // Title
          Text(
            RegistrationStrings.step2Title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            RegistrationStrings.step2Subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Password Field
          CustomTextField(
            label: RegistrationStrings.password,
            hintText: RegistrationStrings.passwordHint,
            controller: widget.controller.passwordController,
            obscureText: widget.controller.obscurePassword,
            onChanged: (value) {
              widget.controller.validatePassword(value);
              setState(() {});
            },
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  widget.controller.togglePasswordVisibility();
                });
              },
              icon: Icon(
                widget.controller.obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 20,
                color: AppColors.textDisabled,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Password Rules
          _buildPasswordRules(),
          const SizedBox(height: 20),

          // Confirm Password
          CustomTextField(
            label: RegistrationStrings.confirmPassword,
            hintText: RegistrationStrings.confirmPasswordHint,
            controller: widget.controller.confirmPasswordController,
            obscureText: widget.controller.obscureConfirmPassword,
            onChanged: (value) {
              widget.controller.validateConfirmPassword(value);
              setState(() {});
            },
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.controller.passwordsMatch &&
                    widget.controller.confirmPasswordController.text.isNotEmpty)
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: AppColors.success,
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.controller.toggleConfirmPasswordVisibility();
                    });
                  },
                  icon: Icon(
                    widget.controller.obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 20,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Next Button
          CustomButton(
            text: RegistrationStrings.next,
            // onPressed: widget.controller.isStep2Valid() ? widget.onNext : null,
            onPressed: widget.onNext,
            // isDisabled: !widget.controller.isStep2Valid(),
            hasShadow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            RegistrationStrings.passwordRules,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          PasswordRuleCheck(
            rule: RegistrationStrings.ruleMinLength,
            isMet: widget.controller.hasMinLength,
          ),
          PasswordRuleCheck(
            rule: RegistrationStrings.ruleNumber,
            isMet: widget.controller.hasNumber,
          ),
          PasswordRuleCheck(
            rule: RegistrationStrings.ruleSpecialChar,
            isMet: widget.controller.hasSpecialChar,
          ),

          // Password match indicator
          const SizedBox(height: 8),
          if (widget.controller.passwordController.text.isNotEmpty &&
              widget.controller.confirmPasswordController.text.isNotEmpty)
            Row(
              children: [
                Icon(
                  widget.controller.passwordsMatch
                      ? Icons.check_circle
                      : Icons.error,
                  size: 20,
                  color: widget.controller.passwordsMatch
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.controller.passwordsMatch
                      ? 'Passwords match'
                      : 'Passwords do not match',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: widget.controller.passwordsMatch
                        ? AppColors.textPrimary
                        : AppColors.error,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}