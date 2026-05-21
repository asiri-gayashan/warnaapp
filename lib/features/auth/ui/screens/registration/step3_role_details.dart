import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/shared/widgets/new/custom_datetime_picker.dart';
import 'package:warna_app/shared/widgets/new/custom_select.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';
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
  List<Map<String, String>> districtsList = [];
  List<Map<String, String>> subjectsList = [];

  @override
  initState() {
    super.initState();
    // Fetch district data when the widget is initialized
    loadDistrictData();
    loadSubjectData();
  }

  Future<void> loadDistrictData() async {
    final rawDistricts = await widget.controller.districtData();

    // print(rawDistricts);
    if (rawDistricts != null) {
      // List<String> districts = List<String>.from(data['districts']);
      setState(() {
        districtsList = rawDistricts
            .map(
              (d) => {"id": d["id"].toString(), "name": d["name"].toString()},
            )
            .toList();
      });
    } else {
      print("Failed to load district data");
    }
  }

  Future<void> loadSubjectData() async {
    final rawSubjects = await widget.controller.SubjectData();

    // print(rawSubjects);
    if (rawSubjects != null) {
      setState(() {
        subjectsList = rawSubjects
            .map(
              (s) => {"id": s["id"].toString(), "name": s["name"].toString()},
            )
            .toList();
      });
    } else {
      print("Failed to load subject data");
    }
  }

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
                ? () async {
                    final response = await widget.controller
                        .registerUser(); // do current task
                    if (response != null && response["status"] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.success,
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(child: Text(response["message"])),

                            ],
                          ),
                        ),
                      );
                    widget.onNext(); // call next function


                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.error,
                          content: Row(
                            children: [
                              Icon(Icons.error, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(child: Text(response == null ? "An error occurred" : response["message"])),

                            ],
                          ),
                        ),
                      );
                    }

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
        NewSelectOptions(
          label: "District*",
          value: widget.controller.selectedDistrict, // stores ID
          items: districtsList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setDistrict(id); // saves ID
            // print("Selected ID: $id"); // prints the UUID
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
          hintText: "Tell us more about your institute",
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

  Widget _buildTeacherForm() {
    return Column(
      children: [
        NewSelectOptions(
          label: "Major Subject*",
          value: widget.controller.selectedMajorSubject, // stores ID
          items: subjectsList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setMajorSubject(id); // saves ID
            print("Selected ID: $id"); // prints the UUID
          },
        ),

        const SizedBox(height: 20),
        NewSelectOptions(
          label: "Grade*",
          value: widget.controller.selectedGrade, // stores ID
          items: SelectOptions.newgradesList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setGrade(id); // saves ID
            // print("Selected ID: $id"); // prints the UUID
          },
        ),

        const SizedBox(height: 20),

        // Years of Experience
        CustomTextField(
          label: "Experience (Years)*",
          hintText: "Enter years of experience (0 - 50)",
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

        NewSelectOptions(
          label: "District*",
          value: widget.controller.selectedDistrict, // stores ID
          items: districtsList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setDistrict(id); // saves ID
            // print("Selected ID: $id"); // prints the UUID
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

        NewSelectOptions(
          label: "Grade*",
          value: widget.controller.selectedGrade, // stores ID
          items: SelectOptions.newgradesList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setGrade(id); // saves ID
            // print("Selected ID: $id"); // prints the UUID
          },
        ),

        const SizedBox(height: 20),

        NewSelectOptions(
          label: "District*",
          value: widget.controller.selectedDistrict, // stores ID
          items: districtsList, // List<Map<String,String>>
          onChanged: (id) {
            widget.controller.setDistrict(id); // saves ID
            // print("Selected ID: $id"); // prints the UUID
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
