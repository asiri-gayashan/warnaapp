import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warna_app/core/utils/api_client.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';

enum TutorClassStatus { ACTIVE, INACTIVE }

class TutorEditClassController extends ChangeNotifier {
  // -----------------------------------------------------------------------
  // Text Controllers
  // -----------------------------------------------------------------------
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classFeesController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // -----------------------------------------------------------------------
  // Dropdown / Picker State
  // -----------------------------------------------------------------------
  String? _selectedGrade;
  String? get selectedGrade => _selectedGrade;

  String? _selectedSubject;
  String? get selectedSubject => _selectedSubject;

  String? _selectedDay;
  String? get selectedDay => _selectedDay;

  TimeOfDay? _startTime;
  TimeOfDay? get startTime => _startTime;

  TimeOfDay? _endTime;
  TimeOfDay? get endTime => _endTime;

  TutorClassStatus _status = TutorClassStatus.ACTIVE;
  TutorClassStatus get status => _status;

  String? _classId;

  // -----------------------------------------------------------------------
  // Pre-fill from existing ClassModel
  // -----------------------------------------------------------------------
  void loadFromModel(ClassModel cls) {
    _classId = cls.id;

    classNameController.text = cls.name;
    classFeesController.text = cls.amount.toStringAsFixed(0);
    locationController.text = cls.location ?? '';
    descriptionController.text = cls.description ?? '';

    _selectedSubject = cls.subjectId;
    _selectedGrade = cls.grade.toString();
    _selectedDay = cls.day.toString();

    _status = cls.status.toUpperCase() == 'ACTIVE'
        ? TutorClassStatus.ACTIVE
        : TutorClassStatus.INACTIVE;

    try {
      final p = cls.startTime.split(':');
      _startTime = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    } catch (_) {}

    try {
      final p = cls.endTime.split(':');
      _endTime = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    } catch (_) {}

    // Pre-filled data is already valid
    _classNameValidated = true;
    _classFeesValidated = true;
    _locationValidated = true;
    _descriptionValidated = true;
    _gradeValidated = true;
    _subjectValidated = true;
    _dayValidated = true;

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Status Toggle
  // -----------------------------------------------------------------------
  void setStatus(TutorClassStatus value) {
    _status = value;
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Class Name Validation
  // -----------------------------------------------------------------------
  bool _classNameValidated = false;
  String? _classNameError;
  String? get classNameError => _classNameError;

  void validateClassName(String value) {
    final v = value.trim();
    final RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (v.isEmpty) {
      _classNameValidated = false;
      _classNameError = "Class name is required";
    } else if (v.length < 5) {
      _classNameValidated = false;
      _classNameError = "Class name must be at least 5 characters";
    } else if (v.length > 100) {
      _classNameValidated = false;
      _classNameError = "Class name must not exceed 100 characters";
    } else if (!regex.hasMatch(v)) {
      _classNameValidated = false;
      _classNameError = "Only letters and numbers allowed";
    } else {
      _classNameValidated = true;
      _classNameError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Class Fees Validation
  // -----------------------------------------------------------------------
  bool _classFeesValidated = false;
  String? _classFeesError;
  String? get classFeesError => _classFeesError;

  void validateClassFees(String value) {
    final v = value.trim();
    final num = double.tryParse(v);

    if (v.isEmpty) {
      _classFeesValidated = false;
      _classFeesError = "Class fees is required";
    } else if (num == null) {
      _classFeesValidated = false;
      _classFeesError = "Invalid amount";
    } else if (num < 0) {
      _classFeesValidated = false;
      _classFeesError = "Fees cannot be negative";
    } else if (num > 100000) {
      _classFeesValidated = false;
      _classFeesError = "Fees limit is 100,000";
    } else {
      _classFeesValidated = true;
      _classFeesError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Location Validation
  // -----------------------------------------------------------------------
  bool _locationValidated = false;
  String? _locationError;
  String? get locationError => _locationError;

  void validateLocation(String value) {
    final v = value.trim();

    if (v.isEmpty) {
      _locationValidated = false;
      _locationError = "Location is required";
    } else if (v.length > 15) {
      _locationValidated = false;
      _locationError = "Location must not exceed 15 characters";
    } else {
      _locationValidated = true;
      _locationError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Description Validation (optional)
  // -----------------------------------------------------------------------
  bool _descriptionValidated = true;
  String? _descriptionError;
  String? get descriptionError => _descriptionError;

  void validateDescription(String value) {
    final v = value.trim();

    if (v.length > 300) {
      _descriptionValidated = false;
      _descriptionError = "Description must not exceed 300 characters";
    } else {
      _descriptionValidated = true;
      _descriptionError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Grade Selection
  // -----------------------------------------------------------------------
  bool _gradeValidated = false;
  String? _gradeError;
  String? get gradeError => _gradeError;

  void setGrade(String? value) {
    _selectedGrade = value;
    if (value == null || value.isEmpty) {
      _gradeValidated = false;
      _gradeError = "Please select a grade";
    } else {
      _gradeValidated = true;
      _gradeError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Subject Selection
  // -----------------------------------------------------------------------
  bool _subjectValidated = false;
  String? _subjectError;
  String? get subjectError => _subjectError;

  void setSubject(String? value) {
    _selectedSubject = value;
    if (value == null || value.isEmpty) {
      _subjectValidated = false;
      _subjectError = "Please select a subject";
    } else {
      _subjectValidated = true;
      _subjectError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Day Selection
  // -----------------------------------------------------------------------
  bool _dayValidated = false;
  String? _dayError;
  String? get dayError => _dayError;

  void setDay(String? value) {
    _selectedDay = value;
    if (value == null || value.isEmpty) {
      _dayValidated = false;
      _dayError = "Please select a day";
    } else {
      _dayValidated = true;
      _dayError = null;
    }
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Time Validation
  // -----------------------------------------------------------------------
  String? _timeError;
  String? get timeError => _timeError;

  void setStartTime(TimeOfDay time) {
    _startTime = time;
    _validateTime();
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    _endTime = time;
    _validateTime();
    notifyListeners();
  }

  void _validateTime() {
    if (_startTime == null || _endTime == null) {
      _timeError = null;
      return;
    }
    final start = _startTime!.hour * 60 + _startTime!.minute;
    final end = _endTime!.hour * 60 + _endTime!.minute;
    _timeError = end <= start ? "End time must be after start time" : null;
  }

  bool get isTimeValid =>
      _startTime != null && _endTime != null && _timeError == null;

  // -----------------------------------------------------------------------
  // Form Validation
  // -----------------------------------------------------------------------
  bool isFormValid() {
    return _classNameValidated &&
        _classFeesValidated &&
        _locationValidated &&
        _descriptionValidated &&
        _gradeValidated &&
        _subjectValidated &&
        _dayValidated &&
        isTimeValid;
  }

  // -----------------------------------------------------------------------
  // Update Class — real API call
  // -----------------------------------------------------------------------
  bool isLoading = false;

  Future<Map<String, dynamic>?> updateClass() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = {
        "name": classNameController.text.trim(),
        "subject_id": _selectedSubject,
        "start_time":
            "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00",
        "end_time":
            "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00",
        "day": int.parse(_selectedDay!),
        "description": descriptionController.text.trim(),
        "amount": double.tryParse(classFeesController.text.trim()) ?? 0,
        "location": locationController.text.trim(),
        "grade": int.parse(_selectedGrade!),
        "status": _status.name,
      };

      final response = await ApiClient.instance.put(
        '/classes/$_classId',
        data: data,
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        return {"status": true, "message": "Class updated successfully"};
      }
      return {"status": false, "message": "Something went wrong"};
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();
      return {
        "status": false,
        "message": e.response?.data?["message"] ?? "Failed to update class",
      };
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return {"status": false, "message": "An error occurred"};
    }
  }

  // -----------------------------------------------------------------------
  // Dispose
  // -----------------------------------------------------------------------
  @override
  void dispose() {
    classNameController.dispose();
    classFeesController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
