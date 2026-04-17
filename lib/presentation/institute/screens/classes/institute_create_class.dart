import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/shared/widgets/new/custom_select.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';

class InstituteCreateClassPage extends StatefulWidget {
  const InstituteCreateClassPage({Key? key}) : super(key: key);

  @override
  State<InstituteCreateClassPage> createState() =>
      _InstituteCreateClassPageState();
}

class _InstituteCreateClassPageState extends State<InstituteCreateClassPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classFeesController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Selected values for dropdowns and time pickers
  String? _selectedTeacher;
  String? _selectedGrade;
  String? _selectedSubject;
  String? _selectedDay;
  String? _selectedHall;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Dummy data for dropdowns
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
  final List<String> _halls = ['Hall A', 'Hall B', 'Hall C', 'Main Lab'];

  @override
  void dispose() {
    _classNameController.dispose();
    _classFeesController.dispose();
    _commissionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

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
              // Class Name
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Class Name',
                hintText: 'E.g. Advanced Mathematics 2024',
                controller: _classNameController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
                isRequired: true,
              ),
              const SizedBox(height: 20),

              CustomSelect(
                label: 'Teacher',
                hintText: 'Select Teacher',
                value: _selectedTeacher,
                options: _teachers
                    .map((t) => SelectOption(value: t, label: t))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTeacher = val),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                isRequired: true,
              ),
              const SizedBox(height: 20),


              CustomSelect(
                label: 'Subject',
                hintText: 'Select Subject',
                value: _selectedSubject,
                options: _subjects
                    .map((s) => SelectOption(value: s, label: s))
                    .toList(),
                onChanged: (val) => setState(() => _selectedSubject = val),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                isRequired: true,
              ),

              // Teacher and Subject
              const SizedBox(height: 20),

              // Grade and Hall
              Row(
                children: [
                  Expanded(
                    child: CustomSelect(
                      label: 'Grade',
                      hintText: 'Select Grade',
                      value: _selectedGrade,
                      options: _grades
                          .map((g) => SelectOption(value: g, label: g))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedGrade = val),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomSelect(
                      label: 'Hall',
                      hintText: 'Select Hall',
                      value: _selectedHall,
                      options: _halls
                          .map((h) => SelectOption(value: h, label: h))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedHall = val),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Day
              CustomSelect(
                label: 'Day',
                hintText: 'Select Day',
                value: _selectedDay,
                options: _days
                    .map((d) => SelectOption(value: d, label: d))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDay = val),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
                isRequired: true,
              ),
              const SizedBox(height: 20),

              // Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Start Time'),
                        GestureDetector(
                          onTap: () => _selectTime(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _startTime?.format(context) ?? 'Select Time',
                                  style: TextStyle(
                                    color: _startTime != null
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('End Time'),
                        GestureDetector(
                          onTap: () => _selectTime(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _endTime?.format(context) ?? 'Select Time',
                                  style: TextStyle(
                                    color: _endTime != null
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fees and Commission
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      
                      label: 'Class Fees (LKR)',
                      hintText: 'E.g. 2500',
                      controller: _classFeesController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Institute Commission (%)',
                      hintText: 'E.g. 20',
                      controller: _commissionController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              CustomTextField(
                label: 'Description',
                hintText: 'Add optional class description or notes...',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _startTime != null &&
                        _endTime != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Class Created Successfully!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } else if (_startTime == null || _endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Please select valid start and end times',
                          ),
                          backgroundColor: Colors.red.shade400,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Class',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
