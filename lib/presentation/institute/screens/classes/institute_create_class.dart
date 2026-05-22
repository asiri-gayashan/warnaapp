import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';
import 'package:warna_app/presentation/institute/controllers/create_class_controller.dart';
import 'package:warna_app/shared/widgets/custom_button.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import 'package:warna_app/shared/widgets/modals/teacher_search_dialog.dart';
import 'package:warna_app/shared/widgets/new/custom_select.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

class InstituteCreateClassPage extends StatefulWidget {
  const InstituteCreateClassPage({Key? key}) : super(key: key);

  @override
  State<InstituteCreateClassPage> createState() =>
      _InstituteCreateClassPageState();
}

class _InstituteCreateClassPageState extends State<InstituteCreateClassPage> {
  final _formKey = GlobalKey<FormState>();
  late CreateClassController controller;
  List<Map<String, String>> subjectsList = [];

  // Dummy data - replace with API data
  final List<String> _teachers = [
    'Dr. Sarah Johnson',
    'Prof. Alan Smith',
    'Mr. David Wilson',
  ];
  final List<String> _grades = [
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
    'A/L',
  ];
  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'Physics',
    'Chemistry',
  ];
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    controller = CreateClassController();
    loadSubjectData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> loadSubjectData() async {
    final rawSubjects = await MetadataRepository().getSubjects();
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

  // -----------------------------------------------------------------------
  // Teacher Search Modal
  // -----------------------------------------------------------------------

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
                  setState(() => controller.setSubject(id)); // saves ID
                  print("Selected ID: $id"); // prints the UUID
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
                  print("Selected ID: $id");
                },
              ),
              FieldErrorText(message: controller.gradeError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Teacher
              // -------------------------------------------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Teacher*',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return TeacherSearchDialog(
                          onSearch: (email) async {
                            return await controller.searchTeacherByEmail(email);
                          },

                          onTeacherSelected: (teacher) {
                            setState(() {
                              controller.setTeacherWithName(
                                teacher['users']['id']?.toString(),
                                teacher['users']['email'],
                              );
                            });
                          },
                        );
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedTeacher != null
                              ? Colors.grey.shade300
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedTeacherEmail ??
                                  'Select Teacher by Email',
                              style: TextStyle(
                                color: controller.selectedTeacher != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FieldErrorText(message: controller.teacherError),
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
              // Time error message
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
                  print("Selected ID: $id");
                },
              ),
              FieldErrorText(message: controller.dayError),
              const SizedBox(height: 20),

              // -------------------------------------------------------
              // Fees & Commission
              // -------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Class Fees (LKR)*',
                          hintText: 'E.g. 2500',
                          controller: controller.classFeesController,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          onChanged: (value) {
                            setState(() => controller.validateClassFees(value));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Commission (%)*',
                          hintText: 'E.g. 20',
                          controller: controller.commissionController,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          onChanged: (value) {
                            setState(
                              () => controller.validateCommission(value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              FieldErrorText(message: controller.classFeesError),
              FieldErrorText(message: controller.commissionError),

              const SizedBox(height: 20),

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
                        final response = await controller
                            .createClass(); // do current task
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

                          Navigator.pop(context);
                        } else {
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
                // onPressed: _buildTeacherForm.,
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
