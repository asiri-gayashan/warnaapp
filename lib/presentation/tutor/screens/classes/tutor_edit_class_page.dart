import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_edit_class_controller.dart';
import 'package:warna_app/shared/widgets/custom_button.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

class TutorEditClassPage extends StatefulWidget {
  final ClassModel classModel;

  const TutorEditClassPage({Key? key, required this.classModel})
      : super(key: key);

  @override
  State<TutorEditClassPage> createState() => _TutorEditClassPageState();
}

class _TutorEditClassPageState extends State<TutorEditClassPage> {
  final _formKey = GlobalKey<FormState>();
  late TutorEditClassController controller;
  List<Map<String, String>> subjectsList = [];

  @override
  void initState() {
    super.initState();
    controller = TutorEditClassController();
    controller.loadFromModel(widget.classModel);
    loadSubjectData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> loadSubjectData() async {
    final rawSubjects = await MetadataRepository().getSubjects();
    if (rawSubjects != null && mounted) {
      setState(() {
        subjectsList = rawSubjects
            .map((s) => {
                  "id": s["id"].toString(),
                  "name": s["name"].toString(),
                })
            .toList();
      });
    }
  }

  // -----------------------------------------------------------------------
  // Time Picker
  // -----------------------------------------------------------------------
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (controller.startTime ?? TimeOfDay.now())
          : (controller.endTime ?? TimeOfDay.now()),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                const Icon(Icons.access_time,
                    color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // Status Toggle Widget
  // -----------------------------------------------------------------------
  Widget _buildStatusToggle() {
    final isActive = controller.status == TutorClassStatus.ACTIVE;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Class Status*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(
                      () => controller.setStatus(TutorClassStatus.ACTIVE)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xff0F6E56)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(11),
                        bottomLeft: Radius.circular(11),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 16,
                            color: isActive
                                ? Colors.white
                                : const Color(0xff888888)),
                        const SizedBox(width: 6),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? Colors.white
                                : const Color(0xff888888),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 48, color: Colors.grey.shade200),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(
                      () => controller.setStatus(TutorClassStatus.INACTIVE)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: !isActive
                          ? const Color(0xffE53935)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(11),
                        bottomRight: Radius.circular(11),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pause_circle_outline,
                            size: 16,
                            color: !isActive
                                ? Colors.white
                                : const Color(0xff888888)),
                        const SizedBox(width: 6),
                        Text(
                          'INACTIVE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: !isActive
                                ? Colors.white
                                : const Color(0xff888888),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isActive
              ? 'Students can view and enroll in this class.'
              : 'This class is hidden from students.',
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? AppColors.success
                : AppColors.error.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // Snackbar helper
  // -----------------------------------------------------------------------
  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color,
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
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
          'Edit Class',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
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

              // Class Name
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

              // Subject — loaded from backend
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

              // Grade
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

              // Start & End Time
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

              // Day
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

              // Class Fees
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
              FieldErrorText(message: controller.classFeesError),
              const SizedBox(height: 20),

              // Location
              CustomTextField(
                label: 'Location*',
                hintText: 'E.g. Kurunegala',
                controller: controller.locationController,
                isRequired: true,
                onChanged: (value) {
                  setState(() => controller.validateLocation(value));
                },
              ),
              FieldErrorText(message: controller.locationError),
              const SizedBox(height: 20),

              // Description
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
              const SizedBox(height: 20),

              // Status Toggle
              _buildStatusToggle(),
              const SizedBox(height: 32),

              // Update Button
              CustomButton(
                text: controller.isLoading ? "Updating..." : "Update Class",
                isDisabled:
                    !controller.isFormValid() || controller.isLoading,
                hasShadow: true,
                onPressed:
                    controller.isFormValid() && !controller.isLoading
                        ? () async {
                            final response =
                                await controller.updateClass();
                            if (!context.mounted) return;
                            if (response != null &&
                                response["status"] == true) {
                              _showSnackBar(
                                response["message"] ??
                                    "Class updated successfully",
                                AppColors.success,
                                Icons.check_circle,
                              );
                              Navigator.pop(context);
                            } else {
                              _showSnackBar(
                                response == null
                                    ? "An error occurred"
                                    : response["message"] ??
                                        "Update failed",
                                AppColors.error,
                                Icons.error,
                              );
                            }
                          }
                        : null,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
