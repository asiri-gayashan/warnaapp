import 'package:flutter/material.dart';

class TutorCreateClassController extends ChangeNotifier {
  // -----------------------------------------------------------------------
  // Text Controllers
  // -----------------------------------------------------------------------
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classFeesController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // -----------------------------------------------------------------------
  // Dropdown / Picker State
  // -----------------------------------------------------------------------
  String? _selectedInstitute;
  String? get selectedInstitute => _selectedInstitute;
  String? _selectedInstituteName;
  String? get selectedInstituteName => _selectedInstituteName;

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

  // -----------------------------------------------------------------------
  // Class Name Validation
  // -----------------------------------------------------------------------
  bool _classNameValidated = false;
  bool get classNameValidated => _classNameValidated;
  String? _classNameError;
  String? get classNameError => _classNameError;

  void validateClassName(String value) {
    final className = value.trim();
    final RegExp classNameRegex = RegExp(r'^[a-zA-Z0-9 ]+$');

    if (className.isEmpty) {
      _classNameValidated = false;
      _classNameError = "Class name is required";
    } else if (className.length < 5) {
      _classNameValidated = false;
      _classNameError = "Class name must be at least 5 characters";
    } else if (className.length > 100) {
      _classNameValidated = false;
      _classNameError = "Class name must not exceed 100 characters";
    } else if (!classNameRegex.hasMatch(className)) {
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
  bool get classFeesValidated => _classFeesValidated;
  String? _classFeesError;
  String? get classFeesError => _classFeesError;

  void validateClassFees(String value) {
    final fees = value.trim();
    final numValue = double.tryParse(fees);

    if (fees.isEmpty) {
      _classFeesValidated = false;
      _classFeesError = "Class fees is required";
    } else if (numValue == null) {
      _classFeesValidated = false;
      _classFeesError = "Invalid amount";
    } else if (numValue < 0) {
      _classFeesValidated = false;
      _classFeesError = "Fees cannot be negative";
    } else if (numValue > 100000) {
      _classFeesValidated = false;
      _classFeesError = "Fees limit is 100,000";
    } else {
      _classFeesValidated = true;
      _classFeesError = null;
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Commission Validation
  // -----------------------------------------------------------------------
  bool _commissionValidated = false;
  bool get commissionValidated => _commissionValidated;
  String? _commissionError;
  String? get commissionError => _commissionError;

  void validateCommission(String value) {
    final commission = value.trim();
    final numValue = double.tryParse(commission);

    if (commission.isEmpty) {
      _commissionValidated = false;
      _commissionError = "Commission is required";
    } else if (numValue == null) {
      _commissionValidated = false;
      _commissionError = "Please enter a valid percentage";
    } else if (numValue < 0 || numValue > 100) {
      _commissionValidated = false;
      _commissionError = "Commission must be between 0 and 100";
    } else {
      _commissionValidated = true;
      _commissionError = null;
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Description Validation
  // -----------------------------------------------------------------------
  bool _descriptionValidated = true; // optional field
  bool get descriptionValidated => _descriptionValidated;
  String? _descriptionError;
  String? get descriptionError => _descriptionError;

  void validateDescription(String value) {
    final description = value.trim();

    if (description.isEmpty) {
      _descriptionValidated = true;
      _descriptionError = null;
    } else if (description.length > 300) {
      _descriptionValidated = false;
      _descriptionError = "Description must not exceed 300 characters";
    } else {
      _descriptionValidated = true;
      _descriptionError = null;
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Institute Selection Validation
  // -----------------------------------------------------------------------
  bool _instituteValidated = false;
  bool get instituteValidated => _instituteValidated;
  String? _instituteError;
  String? get instituteError => _instituteError;

  void setInstitute(String? value) {
    _selectedInstitute = value;

    if (value == null || value.isEmpty) {
      _instituteValidated = false;
      _instituteError = "Please select an institute";
    } else {
      _instituteValidated = true;
      _instituteError = null;
    }

    notifyListeners();
  }

  void setInstituteWithName(String? id, String? name) {
    _selectedInstitute = id;
    _selectedInstituteName = name;

    if (id == null || id.isEmpty) {
      _instituteValidated = false;
      _instituteError = "Please select an institute";
    } else {
      _instituteValidated = true;
      _instituteError = null;
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Grade Selection Validation
  // -----------------------------------------------------------------------
  bool _gradeValidated = false;
  bool get gradeValidated => _gradeValidated;
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
  // Subject Selection Validation
  // -----------------------------------------------------------------------
  bool _subjectValidated = false;
  bool get subjectValidated => _subjectValidated;
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
  // Day Selection Validation
  // -----------------------------------------------------------------------
  bool _dayValidated = false;
  bool get dayValidated => _dayValidated;
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

    if (end <= start) {
      _timeError = "End time must be after start time";
    } else {
      _timeError = null;
    }
  }

  bool get isTimeValid =>
      _startTime != null && _endTime != null && _timeError == null;

  // -----------------------------------------------------------------------
  // Form Validation
  // -----------------------------------------------------------------------
  bool isFormValid() {
    return _classNameValidated &&
        _classFeesValidated &&
        _commissionValidated &&
        _descriptionValidated &&
        _instituteValidated &&
        _gradeValidated &&
        _subjectValidated &&
        _dayValidated &&
        isTimeValid;
  }

  // -----------------------------------------------------------------------
  // Create Class (dummy)
  // -----------------------------------------------------------------------
  bool isLoading = false;

  Future<Map<String, dynamic>?> createClass() async {
    try {
      isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 600));

      final data = {
        "name": classNameController.text.trim(),
        "subject_id": _selectedSubject,
        "institute_id": _selectedInstitute,
        "start_time": _startTime != null
            ? "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00"
            : null,
        "end_time": _endTime != null
            ? "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00"
            : null,
        "day": int.parse(_selectedDay.toString()),
        "description": descriptionController.text.trim(),
        "amount": double.tryParse(classFeesController.text.trim()),
        "institute_commission": double.tryParse(
          commissionController.text.trim(),
        ),
        "grade": int.parse(_selectedGrade.toString()),
      };

      debugPrint("Create Class Payload (dummy): $data");

      isLoading = false;
      notifyListeners();
      return {"status": true, "message": "Class created successfully"};
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Create class error: $e");
      return {"status": false, "message": "An error occurred"};
    }
  }

  // -----------------------------------------------------------------------
  // Search Institute by Email (dummy)
  // -----------------------------------------------------------------------
  Future<Map<String, dynamic>?> searchInstituteByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.trim().isEmpty) {
      return {"status": false, "message": "Institute not found"};
    }

    return {
      "status": true,
      "data": {
        "id": "inst-1",
        "name": "Bright Future Institute",
        "email": email,
        "phone": "+94 77 123 4567",
      },
    };
  }

  // -----------------------------------------------------------------------
  // Dispose
  // -----------------------------------------------------------------------
  @override
  void dispose() {
    classNameController.dispose();
    classFeesController.dispose();
    commissionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
