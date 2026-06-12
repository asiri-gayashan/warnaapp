import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_create_class_controller.dart';
import 'package:warna_app/presentation/tutor/widgets/institute_search_dialog.dart';
import 'package:warna_app/shared/widgets/custom_button.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

class TutorCreateClassPage extends StatefulWidget {
  const TutorCreateClassPage({Key? key}) : super(key: key);

  @override
  State<TutorCreateClassPage> createState() => _TutorCreateClassPageState();
}

class _TutorCreateClassPageState extends State<TutorCreateClassPage> {
  final _formKey = GlobalKey<FormState>();
  late TutorCreateClassController controller;
  final List<Map<String, String>> subjectsList = tutorSubjectsList;

  @override
  void initState() {
    super.initState();
    controller = TutorCreateClassController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------
  // Time Picker
  // -----------------------------------------------------------------------
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          controller.setStartTime(picked);
        } else {
          controller.setEndTime(picked);
        }
      });
    }
  }

  // -----------------------------------------------------------------------
  // Time Picker Widget
  // -----------------------------------------------------------------------
  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime?.format(context) ?? 'Select Time',
                  style: TextStyle(
                    color: selectedTime != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Create Class',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Class Name
              // -------------------------------------------------------
              CustomTextField(
                label: 'Class Name*',
                hintText: 'E.g. Mathematics 2024',
                controller: controller.classNameController,
                isRequired: true,
                onChanged: (value) {
                  setState(() => controller.validateClassName(value));
                },
              ),
              FieldErrorText(message: controller.classNameError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Subject
              // -------------------------------------------------------
              NewSelectOptions(
                label: "Major Subject*",
                value: controller.selectedSubject,
                items: subjectsList,
                onChanged: (id) {
                  setState(() => controller.setSubject(id));
                },
              ),
              FieldErrorText(message: controller.subjectError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Grade
              // -------------------------------------------------------
              NewSelectOptions(
                label: "Grade*",
                value: controller.selectedGrade,
                items: SelectOptions.newgradesList,
                onChanged: (id) {
                  setState(() => controller.setGrade(id));
                },
              ),
              FieldErrorText(message: controller.gradeError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Start & End Time
              // -------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      label: 'Start Time*',
                      selectedTime: controller.startTime,
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePicker(
                      label: 'End Time*',
                      selectedTime: controller.endTime,
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              if (controller.timeError != null)
                FieldErrorText(message: controller.timeError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Day
              // -------------------------------------------------------
              NewSelectOptions(
                label: "Day*",
                value: controller.selectedDay,
                items: SelectOptions.days,
                onChanged: (id) {
                  setState(() => controller.setDay(id));
                },
              ),
              FieldErrorText(message: controller.dayError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Fees &
              // -------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Class Fees (LKR)*',
                      hintText: 'E.g. 2500',
                      controller: controller.classFeesController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      onChanged: (value) {
                        setState(() => controller.validateClassFees(value));
                      },
                    ),
                  ),
                ],
              ),
              FieldErrorText(message: controller.classFeesError),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Location*',
                hintText: 'Kururnegala',
                controller: controller.classFeesController,
                keyboardType: TextInputType.number,
                isRequired: true,
                onChanged: (value) {
                  setState(() => controller.validateClassFees(value));
                },
              ),
              const SizedBox(height: 20),

              //todo - add this location fileed data to the controller. location should have 10 charachters maximum and should not be empty. also add the error message to the controller and show it in the UI using FieldErrorText widget.

              // -------------------------------------------------------
              // Description
              // -------------------------------------------------------
              CustomTextField(
                label: 'Description',
                hintText: 'Add optional class description or notes...',
                controller: controller.descriptionController,
                maxLines: 4,
                onChanged: (value) {
                  setState(() => controller.validateDescription(value));
                },
              ),
              FieldErrorText(message: controller.descriptionError),
              const SizedBox(height: 32),

              // -------------------------------------------------------
              // Submit Button
              // -------------------------------------------------------
              CustomButton(
                text: "Create Class",
                onPressed: controller.isFormValid()
                    ? () async {
                        final response = await controller.createClass();
                        if (response != null && response["status"] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.success,
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(response["message"])),
                                ],
                              ),
                            ),
                          );

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.error,
                              content: Row(
                                children: [
                                  const Icon(Icons.error, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      response == null
                                          ? "An error occurred"
                                          : response["message"],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                isDisabled: !controller.isFormValid(),
                hasShadow: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
