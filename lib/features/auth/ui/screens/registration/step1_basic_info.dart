import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../shared/widgets/role_selection_card.dart';
import '../../../../../shared/widgets/step_progress_indicator.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/registration_strings.dart';
import '../../../logic/registration_controller.dart';

class RegistrationStep1 extends StatefulWidget {
  final RegistrationController controller;
  final VoidCallback onNext;

  const RegistrationStep1({
    Key? key,
    required this.controller,
    required this.onNext,
  }) : super(key: key);

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Progress Indicator
          StepProgressIndicator(
            currentStep: 1,
            totalSteps: 4,
            stepLabels: const [
              RegistrationStrings.step1,
              RegistrationStrings.step2,
              RegistrationStrings.step3,
              RegistrationStrings.step4,
            ],
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            RegistrationStrings.step1Title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            RegistrationStrings.step1Subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 40),

          // Role Selection
          _buildRoleSelection(),
          const SizedBox(height: 32),

          // Form Fields
          _buildFormFields(),
          const SizedBox(height: 48),

          // Next Button
          CustomButton(
            text: RegistrationStrings.next,
            onPressed: widget.controller.isStep1Valid() ? widget.onNext : null,
            isDisabled: !widget.controller.isStep1Valid(),
            hasShadow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          RegistrationStrings.selectRole,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),

        // Role Cards
        Column(
          children: [
            // Institute Admin Card
            RoleSelectionCard(
              title: RegistrationStrings.roleAdmin,
              description: RegistrationStrings.roleAdminDesc,
              icon: Icons.school,
              iconColor: AppColors.iconAdmin,
              iconBackgroundColor: AppColors.iconBgAdmin,
              isSelected: widget.controller.selectedRole == UserRole.instituteAdmin,
              onTap: () => widget.controller.selectRole(UserRole.instituteAdmin),
            ),
            const SizedBox(height: 16),

            // Teacher Card
            RoleSelectionCard(
              title: RegistrationStrings.roleTeacher,
              description: RegistrationStrings.roleTeacherDesc,
              icon: Icons.person,
              iconColor: AppColors.iconTeacher,
              iconBackgroundColor: AppColors.iconBgTeacher,
              isSelected: widget.controller.selectedRole == UserRole.teacher,
              onTap: () => widget.controller.selectRole(UserRole.teacher),
            ),
            const SizedBox(height: 16),

            // Student Card
            RoleSelectionCard(
              title: RegistrationStrings.roleStudent,
              description: RegistrationStrings.roleStudentDesc,
              icon: Icons.school_outlined,
              iconColor: AppColors.iconStudent,
              iconBackgroundColor: AppColors.iconBgStudent,
              isSelected: widget.controller.selectedRole == UserRole.student,
              onTap: () => widget.controller.selectRole(UserRole.student),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // First Name
        CustomTextField(
          label: RegistrationStrings.firstName,
          hintText: RegistrationStrings.firstNameHint,
          controller: widget.controller.firstNameController,
          onChanged: (value) => widget.controller.notifyListeners(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return RegistrationStrings.firstNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Email Address with Real-time Validation
        CustomTextField(
          label: RegistrationStrings.emailAddress,
          hintText: RegistrationStrings.emailHint,
          controller: widget.controller.emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            widget.controller.validateEmailRealTime(value);
            widget.controller.notifyListeners();
          },
          validator: (value) => widget.controller.validateEmail(value ?? ''),
          suffixIcon: widget.controller.emailController.text.isNotEmpty
              ? widget.controller.emailValidated
              ? const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          )
              : widget.controller.emailError != null
              ? const Icon(
            Icons.error,
            color: AppColors.error,
            size: 20,
          )
              : null
              : null,
        ),
        const SizedBox(height: 20),

        // Mobile Number
        CustomTextField(
          label: RegistrationStrings.mobileNumber,
          hintText: RegistrationStrings.mobileHint,
          controller: widget.controller.mobileController,
          keyboardType: TextInputType.phone,
          onChanged: (value) => widget.controller.notifyListeners(),
          validator: (value) => widget.controller.validateMobile(value ?? ''),
        ),
      ],
    );
  }
}