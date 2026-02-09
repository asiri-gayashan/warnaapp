import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../shared/widgets/role_selection_card.dart';
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
          // Title
          Text(
            RegistrationStrings.step1Title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            RegistrationStrings.step1Subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Institute Admin Card
        RoleSelectionCard(
          title: RegistrationStrings.roleAdmin,
          description: RegistrationStrings.roleAdminDesc,
          icon: Icons.school,
          color: AppColors.roleAdmin,
          isSelected: widget.controller.selectedRole == UserRole.instituteAdmin,
          onTap: () => setState(() {
            widget.controller.selectRole(UserRole.instituteAdmin);
          }),
        ),

        // Teacher Card
        RoleSelectionCard(
          title: RegistrationStrings.roleTeacher,
          description: RegistrationStrings.roleTeacherDesc,
          icon: Icons.person,
          color: AppColors.roleTeacher,
          isSelected: widget.controller.selectedRole == UserRole.teacher,
          onTap: () => setState(() {
            widget.controller.selectRole(UserRole.teacher);
          }),
        ),

        // Student Card
        RoleSelectionCard(
          title: RegistrationStrings.roleStudent,
          description: RegistrationStrings.roleStudentDesc,
          icon: Icons.school_outlined,
          color: AppColors.roleStudent,
          isSelected: widget.controller.selectedRole == UserRole.student,
          onTap: () => setState(() {
            widget.controller.selectRole(UserRole.student);
          }),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Full Name
        CustomTextField(
          label: RegistrationStrings.fullName,
          hintText: RegistrationStrings.fullNameHint,
          controller: widget.controller.fullNameController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        // Email Address
        CustomTextField(
          label: RegistrationStrings.emailAddress,
          hintText: RegistrationStrings.emailHint,
          controller: widget.controller.emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            widget.controller.validateEmail(value);
            setState(() {});
          },
          suffixIcon: widget.controller.emailController.text.isNotEmpty
              ? widget.controller.emailValidated
              ? const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          )
              : const Icon(
            Icons.error,
            color: AppColors.error,
            size: 20,
          )
              : null,
        ),
        const SizedBox(height: 20),

        // Mobile Number
        CustomTextField(
          label: RegistrationStrings.mobileNumber,
          hintText: RegistrationStrings.mobileHint,
          controller: widget.controller.mobileController,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }
}