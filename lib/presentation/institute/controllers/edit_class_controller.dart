import 'package:flutter/material.dart';
import 'package:warna_app/data/models/class_model.dart';
import '../../../core/network/dio_client.dart';
import 'package:dio/dio.dart';

enum ClassStatus { ACTIVE, INACTIVE }

class EditClassController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // -----------------------------------------------------------------------
  // Text Controllers
  // -----------------------------------------------------------------------
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classFeesController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tutorNameController = TextEditingController();

  // -----------------------------------------------------------------------
  // Dropdown / Picker State
  // -----------------------------------------------------------------------
  String? _selectedTeacher;
  String? get selectedTeacher => _selectedTeacher;
  String? _selectedTeacherEmail;
  String? get selectedTeacherEmail => _selectedTeacherEmail;

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

  ClassStatus _status = ClassStatus.ACTIVE;
  ClassStatus get status => _status;

  String? _classId;

  // -----------------------------------------------------------------------
  // Pre-fill from existing ClassModel
  // -----------------------------------------------------------------------
  void loadFromModel(ClassModel cls) {
    _classId = cls.id;

    classNameController.text = cls.name;
    classFeesController.text = cls.amount.toString();
    commissionController.text = cls.instituteCommission.toString();
    descriptionController.text = cls.description;
    tutorNameController.text = cls.tutorName;


    _selectedSubject = cls.subjectId;
    _selectedGrade = cls.grade.toString();
    _selectedDay = cls.day.toString();
    _selectedTeacher = cls.tutorId;
    _selectedTeacherEmail = cls.tutorName;

    _status = cls.status.toUpperCase() == 'ACTIVE'
        ? ClassStatus.ACTIVE
        : ClassStatus.INACTIVE;

    // Parse startTime (HH:mm:ss or HH:mm)
    try {
      final startParts = cls.startTime.split(':');
      _startTime = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
    } catch (_) {}

    // Parse endTime
    try {
      final endParts = cls.endTime.split(':');
      _endTime = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );
    } catch (_) {}

    // Mark all fields as validated since data is pre-filled
    _classNameValidated = true;
    _classFeesValidated = true;
    _commissionValidated = true;
    _descriptionValidated = true;
    _teacherValidated = true;
    _gradeValidated = true;
    _subjectValidated = true;
    _dayValidated = true;

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // Status Toggle
  // -----------------------------------------------------------------------
  void setStatus(ClassStatus value) {
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
  bool _descriptionValidated = true;
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
  // Teacher Selection
  // -----------------------------------------------------------------------
  bool _teacherValidated = false;
  String? _teacherError;
  String? get teacherError => _teacherError;

  void setTeacherWithName(String? id, String? email) {
    _selectedTeacher = id;
    _selectedTeacherEmail = email;

    if (id == null || id.isEmpty) {
      _teacherValidated = false;
      _teacherError = "Please select a teacher";
    } else {
      _teacherValidated = true;
      _teacherError = null;
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
        _teacherValidated &&
        _gradeValidated &&
        _subjectValidated &&
        _dayValidated &&
        isTimeValid;
  }

  // -----------------------------------------------------------------------
  // API Call - Update Class
  // -----------------------------------------------------------------------
  bool isLoading = false;

  Future<Map<String, dynamic>?> updateClass() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = {
        "name": classNameController.text.trim(),
        "subject_id": _selectedSubject,
        "tutor_id": _selectedTeacher,
        "start_time": _startTime != null
            ? "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00"
            : null,
        "end_time": _endTime != null
            ? "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00"
            : null,
        "day": int.parse(_selectedDay.toString()),
        "description": descriptionController.text.trim(),
        "amount": double.tryParse(classFeesController.text.trim()),
        "institute_commission":
            double.tryParse(commissionController.text.trim()),
        "grade": int.parse(_selectedGrade.toString()),
        "status": _status.name, // "ACTIVE" or "INACTIVE"
      };

      print(data);
      

      final response = await _dio.put("/classes/$_classId", data: data);

      isLoading = false;
      notifyListeners();
      return response.data;
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();
      print(e.response?.data);
      return e.response?.data;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
      return null;
    }
  }

  // -----------------------------------------------------------------------
  // API Call - Search Teacher by Email
  // -----------------------------------------------------------------------
  Future<Map<String, dynamic>?> searchTeacherByEmail(String email) async {
    try {
      final response = await _dio.get("/teachers/email/$email");
      return response.data;
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
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