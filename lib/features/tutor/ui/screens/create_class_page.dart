import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/features/tutor/models/class_model.dart';
import 'package:warna_app/services/token_service.dart';
import 'package:warna_app/shared/widgets/custom_button.dart';
import 'package:warna_app/shared/widgets/custom_textfield.dart';
import 'package:warna_app/shared/widgets/customselect.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({Key? key}) : super(key: key);

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  // Controllers for text fields
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Selected values for dropdowns
  String? _selectedDay;
  String? _selectedSubject;
  String? _selectedGrade;
  String? _selectedDuration;

  // Error states
  String? _subjectError;
  String? _gradeError;
  String? _dayError;
  String? _timeError;
  String? _durationError;
  String? _locationError;
  String? _classNameError;
  String? _descriptionError;

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Add listeners for real-time validation if needed
    _subjectController.addListener(_validateSubject);
    _gradeController.addListener(_validateGrade);
    _timeController.addListener(_validateTime);
    _durationController.addListener(_validateDuration);
    _locationController.addListener(_validateLocation);
    _classNameController.addListener(_validateClassname);
    _descriptionController.addListener(_validateDescription);
  }

  // Validation methods
  void _validateSubject() {
    setState(() {
      if (_subjectController.text.isEmpty) {
        _subjectError = 'Subject is required';
      } else if (_subjectController.text.length < 3) {
        _subjectError = 'Subject must be at least 3 characters';
      } else {
        _subjectError = null;
      }
    });
  }

  void _validateGrade() {
    setState(() {
      if (_selectedGrade == null || _selectedGrade!.isEmpty) {
        _gradeError = 'Please select a grade';
      } else {
        _gradeError = null;
      }
    });
  }

  void _validateTime() {
    setState(() {
      if (_timeController.text.isEmpty) {
        _timeError = 'Time is required';
      } else {
        // Basic time format validation (HH:MM AM/PM)
        final timeRegex = RegExp(r'^(1[0-2]|0?[1-9]):[0-5][0-9] (AM|PM)$');
        if (!timeRegex.hasMatch(_timeController.text)) {
          _timeError = 'Use format: 10:30 AM';
        } else {
          _timeError = null;
        }
      }
    });
  }

  void _validateDuration() {
    setState(() {
      if (_durationController.text.isEmpty) {
        _durationError = 'Duration is required';
      } else {
        _durationError = null;
      }
    });
  }

  void _validateLocation() {
    setState(() {
      if (_locationController.text.isEmpty) {
        _locationError = 'Location is required';
      } else {
        _locationError = null;
      }
    });
  }



  void _validateClassname() {
    setState(() {
      if (_classNameController.text.isEmpty) {
        _classNameError = 'Class name is required';
      } else if(_classNameController.text.trim().length > 20){
        _classNameError = 'Characters limit is 20';
      }else {
        _classNameError = null;
      }
    });
  }



  void _validateDescription() {
    setState(() {
      if (_descriptionController.text.isEmpty) {
        _descriptionError = 'Description is required';
      } else if (_descriptionController.text.length < 20) {
        _descriptionError = 'Description must be at least 20 characters';
      } else {
        _descriptionError = null;
      }
    });
  }

  bool get _isFormValid {
    return _subjectError == null &&
        _gradeError == null &&
        _dayError == null &&
        _timeError == null &&
        _durationError == null &&
        _locationError == null &&
        _classNameError == null &&
        _descriptionError == null &&
        _selectedSubject != null &&
        _selectedSubject!.isNotEmpty &&
        _selectedGrade != null &&
        _selectedGrade!.isNotEmpty &&
        _selectedDay != null &&
        _timeController.text.isNotEmpty &&
        _durationController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  Future<void> _createClass() async {
    // Validate all fields
    _validateSubject();
    _validateGrade();
    _validateTime();
    _validateDuration();
    _validateLocation();
    _validateClassname();
    _validateDescription();


    String? userId = await TokenService.getUserId();


    setState(() {
      if (_selectedDay == null) _dayError = 'Please select a day';
      if (_selectedSubject == null) _subjectError = 'Please select a subject';
      if (_selectedGrade == null) _gradeError = 'Please select a grade';
    });

    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });




    try {
      final newClass = {
        "name": _classNameController.text,
        "subject": _selectedSubject ?? _subjectController.text,
        "grade": _selectedGrade!,
        "day": _selectedDay!,
        "teacherId": userId,
        "time": _timeController.text,
        "duration": _durationController.text,
        "description": _descriptionController.text,
        "location": _locationController.text,
        "status": true,
        "instituteId": null,
      };


      // TODO: Save to backend
      // print(newClass);


      print("Sending data:");

      final response = await http.post(
        Uri.parse("http://10.0.2.2:5001/api/classes/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(newClass),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");



      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Class created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, newClass);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create class: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create New Class',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.video_call,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fill in the information below to create a new class',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Basic Information Section
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),


            CustomTextField(
              label: 'Class Name*',
              hintText: 'Your Class Name',
              controller: _classNameController,
              onChanged: (value) {
                _validateClassname();
              },
            ),
            if (_classNameError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _classNameError!),
            ],


            const SizedBox(height: 20),


            // Subject Field
            CreativeSelect(
              label: 'Subject*',
              items: SelectOptions.subjects,
              value: _selectedSubject,
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                  _subjectController.text = value ?? '';
                });
                _validateSubject();
              },
            ),
            if (_subjectError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _subjectError!),
            ],

            const SizedBox(height: 20),

            // Grade Field


            CreativeSelect(
              label: 'Grade*',
              items: SelectOptions.gradesList,
              value: _selectedGrade,
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value;
                  _gradeController.text = value ?? '';
                });
                _validateGrade();
              },
            ),
            if (_gradeError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _gradeError!),
            ],


            const SizedBox(height: 24),

            // Schedule Section
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Day Selection
            CreativeSelect(
              label: 'Day*',
              items: SelectOptions.daysList,
              value: _selectedDay,
              onChanged: (value) {
                setState(() {
                  _selectedDay = value;
                  _dayError = value == null ? 'Day is required' : null;
                });
              },
            ),
            if (_dayError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _dayError!),
            ],

            const SizedBox(height: 20),

            // Time Field
            CustomTextField(
              label: 'Time*',
              hintText: 'e.g., 10:30 AM',
              controller: _timeController,
              onChanged: (value) {
                _validateTime();
              },
            ),
            if (_timeError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _timeError!),
            ],

            const SizedBox(height: 20),

            // Duration Field
            CustomTextField(
              label: 'Duration*',
              hintText: 'e.g., 60 min, 90 min, etc.',
              controller: _durationController,
              onChanged: (value) {
                _validateDuration();
              },
            ),
            if (_durationError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _durationError!),
            ],

            const SizedBox(height: 24),

            // Class Details Section
            const Text(
              'Class Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Location Field
            CustomTextField(
              label: 'Location*',
              hintText: 'e.g., Online (Zoom), Room 101, etc.',
              controller: _locationController,
              onChanged: (value) {
                _validateLocation();
              },
            ),
            if (_locationError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _locationError!),
            ],

            const SizedBox(height: 20),

            // Description Field
            CustomTextField(
              label: 'Description*',
              hintText: 'Describe what students will learn, prerequisites, etc.',
              controller: _descriptionController,
              maxLines: 4,
              onChanged: (value) {
                _validateDescription();
              },
            ),
            if (_descriptionError != null) ...[
              const SizedBox(height: 4),
              FieldErrorText(message: _descriptionError!),
            ],

            const SizedBox(height: 30),

            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                // Create Button
                Expanded(
                  child: CustomButton(
                    text: _isLoading ? 'Creating...' : 'Create Class',
                    onPressed: _isLoading ? null : _createClass,
                    isDisabled: !_isFormValid || _isLoading,
                    hasShadow: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _gradeController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _classNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}