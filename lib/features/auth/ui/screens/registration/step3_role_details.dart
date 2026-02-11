import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/shared/widgets/custom_select.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../shared/widgets/customselect.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/registration_strings.dart';
import '../../../logic/registration_controller.dart';


class RegistrationStep3 extends StatefulWidget {
  final RegistrationController controller;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegistrationStep3({
    Key? key,
    required this.controller,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button

          const SizedBox(height: 25),


          // Title based on role
          _buildTitle(),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Please provide additional details',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Role-specific form
          _buildRoleSpecificForm(),
          const SizedBox(height: 40),

          // Next Button
          CustomButton(
            text: RegistrationStrings.next,
            // onPressed: widget.controller.isStep3Valid() ? widget.onNext : null,
            onPressed: widget.onNext,

            // isDisabled: !widget.controller.isStep3Valid(),
            hasShadow: true,
          ),
          const SizedBox(height: 40),

        ],
      ),
    );
  }

  Widget _buildTitle() {
    switch (widget.controller.selectedRole) {
      case UserRole.instituteAdmin:
        return Text(
          RegistrationStrings.step3TitleAdmin,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        );
      case UserRole.teacher:
        return Text(
          RegistrationStrings.step3TitleTeacher,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        );
      case UserRole.student:
        return Text(
          RegistrationStrings.step3TitleStudent,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildRoleSpecificForm() {
    switch (widget.controller.selectedRole) {
      case UserRole.instituteAdmin:
        return _buildAdminForm();
      case UserRole.teacher:
        return _buildTeacherForm();
      case UserRole.student:
        return _buildStudentForm();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAdminForm() {
    return Column(
      children: [
        // Institute Name
        CustomTextField(
          label: RegistrationStrings.instituteName,
          hintText: RegistrationStrings.instituteNameHint,
          controller: widget.controller.instituteNameController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        // Institute Type Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              RegistrationStrings.instituteType,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: widget.controller.instituteType,
              decoration: InputDecoration(
                hintText: RegistrationStrings.instituteTypeHint,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'School', child: Text('School')),
                DropdownMenuItem(value: 'Tuition', child: Text('Tuition Center')),
                DropdownMenuItem(value: 'Academy', child: Text('Academy')),
                DropdownMenuItem(value: 'College', child: Text('College')),
                DropdownMenuItem(value: 'University', child: Text('University')),
              ],
              onChanged: (value) {
                setState(() {
                  widget.controller.setInstituteType(value);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Address
        CustomTextField(
          label: RegistrationStrings.address,
          hintText: RegistrationStrings.addressHint,
          controller: widget.controller.addressController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        // City
        CustomTextField(
          label: RegistrationStrings.city,
          hintText: RegistrationStrings.cityHint,
          controller: widget.controller.cityController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        // Number of Teachers (Optional)
        CustomTextField(
          label: RegistrationStrings.numberOfTeachers,
          hintText: RegistrationStrings.teachersHint,
          controller: widget.controller.teachersCountController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildTeacherForm() {
    return Column(
      children: [
        // Subjects Taught



        CreativeSelect(
          label: "Major Subject",
          items: ["Science", "English",  "History", "Music", "Geography"],
          onChanged: (value) {
            debugPrint("Selected: $value");
          },
        ),

        const SizedBox(height: 20),


        // Years of Experience
        CustomTextField(
          label: RegistrationStrings.experience,
          hintText: RegistrationStrings.experienceHint,
          controller: widget.controller.experienceController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 20),

        CreativeSelect(
          label: "Province",
          items: ["Western", "North Western",  "Central", "Southern", "Eastern"],
          onChanged: (value) {
            debugPrint("Selected: $value");
          },
        ),

        const SizedBox(height: 20),

        CustomTextField(
          label: "Address Line 1",
          hintText: "Address",
          // controller: widget.controller.schoolController,
        ),

        const SizedBox(height: 20),


        CustomTextField(
          label: "Address Line 2",
          hintText: "Address",
          controller: widget.controller.schoolController,
        ),




      ],
    );
  }

  Widget _buildStudentForm() {
    return Column(
      children: [

        // Grade

        CustomTextField(
          label: RegistrationStrings.school,
          hintText: RegistrationStrings.schoolHint,
          controller: widget.controller.schoolController,
        ),

        const SizedBox(height: 20),


        CreativeSelect(
          label: "Grade",
          items: ["Grade 1", "Grade 2", "Grade 3", "Grade 4"],
          onChanged: (value) {
            debugPrint("Selected: $value");
          },
        ),

        const SizedBox(height: 20),



        CreativeSelect(
          label: "Province",
          items: ["Western", "North Western",  "Central", "Southern", "Eastern"],
          onChanged: (value) {
            debugPrint("Selected: $value");
          },
        ),

        const SizedBox(height: 20),



        // Address

        CustomTextField(
          label: "Address Line 1",
          hintText: "Address",
          controller: widget.controller.schoolController,
        ),

        const SizedBox(height: 20),


        CustomTextField(
          label: "Address Line 2",
          hintText: "Address",
          controller: widget.controller.schoolController,
        ),






      ],
    );
  }
}


  

