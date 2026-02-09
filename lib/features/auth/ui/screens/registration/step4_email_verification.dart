import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/otp_input_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/registration_strings.dart';
import '../../../logic/registration_controller.dart';

class RegistrationStep4 extends StatefulWidget {
  final RegistrationController controller;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegistrationStep4({
    Key? key,
    required this.controller,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  State<RegistrationStep4> createState() => _RegistrationStep4State();
}

class _RegistrationStep4State extends State<RegistrationStep4> {
  @override
  void initState() {
    super.initState();
    // Start resend timer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.startResendTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button


          // Title
          Text(
            RegistrationStrings.step4Title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            RegistrationStrings.step4Subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // OTP Instructions
          RichText(
            text: TextSpan(
              text: '${RegistrationStrings.otpInstruction} ',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: widget.controller.emailController.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // OTP Input Field
          OtpInputField(
            onCompleted: (otp) {
              widget.controller.setOtp(otp);
              setState(() {});
            },
          ),
          const SizedBox(height: 32),

          // Verify Button
          CustomButton(
            text: RegistrationStrings.verifyButton,
            onPressed: () {
              // Verify OTP (simulate)
              widget.controller.verifyOtp();
              widget.onNext();
            },
            hasShadow: true,
          ),
          const SizedBox(height: 24),

          // Resend Code Section
          Center(
            child: Column(
              children: [
                Text(
                  "Didn't receive the code?",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                widget.controller.isResendEnabled
                    ? TextButton(
                  onPressed: () {
                    // Resend OTP logic
                    widget.controller.startResendTimer();
                    setState(() {});
                  },
                  child: Text(
                    RegistrationStrings.resendCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                )
                    : Text(
                  '${RegistrationStrings.resendIn} ${widget.controller.resendTimer} ${RegistrationStrings.seconds}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}