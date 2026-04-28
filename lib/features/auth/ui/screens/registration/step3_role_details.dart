import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/shared/widgets/new/custom_datetime_picker.dart';
import 'package:warna_app/shared/widgets/new/custom_select.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/new/custom_textfield.dart';
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
            onPressed: widget.controller.isStep3Valid()
                ? () {
                    widget.controller.printData(); // do current task
                    widget.onNext(); // call next function
                  }
                : null,
            // onPressed: _buildTeacherForm.,
            isDisabled: !widget.controller.isStep3Valid(),
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
        // CustomTextField(
        //   label: RegistrationStrings.instituteName,
        //   hintText: RegistrationStrings.instituteNameHint,
        //   controller: widget.controller.instituteNameController,
        //   onChanged: (value) {
        //     widget.controller.validateInstituteName(value);
        //   },
        // ),
        //
        //
        // FieldErrorText( message: widget.controller.instituteNameError),
        //
        // const SizedBox(height: 20),
        CreativeSelect(
          label: "Student Count*",
          items: SelectOptions.studentCountList,
          value: widget.controller.selectedStudentCount,
          onChanged: (value) {
            widget.controller.setStudentCount(value);
          },
        ),
        const SizedBox(height: 20),

        CreativeSelect(
          label: "Teacher Count*",
          items: SelectOptions.teacherCountList,
          value: widget.controller.selectedTeacherCount,
          onChanged: (value) {
            widget.controller.setTeacherCount(value);
          },
        ),
        const SizedBox(height: 20),

        CreativeSelect(
          label: "District*",
          value: widget.controller.selectedDistrict,
          items: SelectOptions.districtsList,
          onChanged: (value) {
            widget.controller.setDistrict(value);
          },
        ),
        const SizedBox(height: 20),

        //
        CustomTextField(
          label: "Address*",
          hintText: "Address",
          controller: widget.controller.addressController,
          onChanged: (value) {
            widget.controller.validateAddressOne(value);
          },
        ),
        FieldErrorText(message: widget.controller.addressOneError),
      ],
    );
  }

  Widget _buildTeacherForm() {
    return Column(
      children: [
        // Subjects Taught
        CreativeSelect(
          label: "Major Subject*",
          value: widget.controller.selectedMajorSubject,
          items: SelectOptions.subjects,
          onChanged: (value) {
            widget.controller.setMajorSubject(value);
          },
        ),
        const SizedBox(height: 20),

        CreativeSelect(
          label: "Grade*",
          items: SelectOptions.gradesList,
          value: widget.controller.selectedGrade,
          onChanged: (value) {
            widget.controller.setGrade(value);
          },
        ),
        const SizedBox(height: 20),

        // Years of Experience
        CustomTextField(
          label: "Experience (Years)*",
          hintText: "Enter years of experience (0 - 100)",
          controller: widget.controller.experienceController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.controller.validateExperience(value);
          },
        ),
        FieldErrorText(message: widget.controller.experienceError),

        const SizedBox(height: 20),

        CustomDateTimePicker(
          mode: PickerMode.date,
          label: "Birthday",
          hintText: "Select Date",
          selectedDate: widget.controller.selectedBirthday,
          onDateSelected: (date) => widget.controller.setBirthday(date),
        ),
        const SizedBox(height: 20),

        CreativeSelect(
          label: "District*",
          value: widget.controller.selectedDistrict,
          items: SelectOptions.districtsList,
          onChanged: (value) {
            widget.controller.setDistrict(value);
          },
        ),
        const SizedBox(height: 20),

        // Address
        CustomTextField(
          label: "Address Line 1*",
          hintText: "Address",
          controller: widget.controller.addressController,
          onChanged: (value) {
            widget.controller.validateAddressOne(value);
          },
        ),
        FieldErrorText(message: widget.controller.addressOneError),

        const SizedBox(height: 20),

        CustomTextField(
          label: "Address Line 2",
          hintText: "Optional",
          controller: widget.controller.addressTwoController,
          onChanged: (value) {
            widget.controller.validateAddressTwo(value);
          },
        ),
        FieldErrorText(message: widget.controller.addressTwoError),

        const SizedBox(height: 20),

        CustomTextField(
          label: "Description",
          hintText: "Tell us more about you",
          maxLines: 4,
          controller: widget.controller.descriptionController,
          onChanged: (value) {
            widget.controller.validateDescription(value);
          },
        ),
        FieldErrorText(message: widget.controller.descriptionError),
      ],
    );
  }

  Widget _buildStudentForm() {
    return Column(
      children: [
        // Grade
        CustomTextField(
          label: "School",
          hintText: "Your School",
          controller: widget.controller.schoolController,
          onChanged: (value) {
            widget.controller.validateSchoolName(value);
          },
        ),
        FieldErrorText(message: widget.controller.schoolNameError),

        const SizedBox(height: 20),

        CustomDateTimePicker(
          mode: PickerMode.date,
          label: "Birthday",
          hintText: "Select Date",
          selectedDate: widget.controller.selectedBirthday,
          onDateSelected: (date) => widget.controller.setBirthday(date),
        ),

        const SizedBox(height: 20),

        CreativeSelect(
          label: "Grade*",
          items: SelectOptions.gradesList,
          value: widget.controller.selectedGrade,
          onChanged: (value) {
            widget.controller.setGrade(value);
          },
        ),

        const SizedBox(height: 20),

        CreativeSelect(
          label: "District*",
          value: widget.controller.selectedDistrict,
          items: SelectOptions.districtsList,
          onChanged: (value) {
            widget.controller.setDistrict(value);
          },
        ),
        const SizedBox(height: 20),

        // Address
        CustomTextField(
          label: "Address Line 1*",
          hintText: "Address",
          controller: widget.controller.addressController,
          onChanged: (value) {
            widget.controller.validateAddressOne(value);
          },
        ),
        FieldErrorText(message: widget.controller.addressOneError),

        const SizedBox(height: 20),

        CustomTextField(
          label: "Address Line 2",
          hintText: "Optional",
          controller: widget.controller.addressTwoController,
          onChanged: (value) {
            widget.controller.validateAddressTwo(value);
          },
        ),
        FieldErrorText(message: widget.controller.addressTwoError),

        const SizedBox(height: 20),

        CustomTextField(
          label: "Description",
          hintText: "Tell us more about you",
          maxLines: 4,
          controller: widget.controller.descriptionController,
          onChanged: (value) {
            widget.controller.validateDescription(value);
          },
        ),
        FieldErrorText(message: widget.controller.descriptionError),
      ],
    );
  }
}
