import 'package:flutter/material.dart';

// ============================================================
// MODEL  — matches the `classes` Prisma schema exactly
// Fields marked nullable (?) in the schema are String?/int?/double? here.
// ============================================================

class ClassModel {
  final String id;
  final String name;
  final String subjectId;
  final String tutorId;
  final String? instituteId;       // schema: String?
  final String startTime;
  final String endTime;
  final int day;
  final String? description;       // schema: String?
  final String status;
  final DateTime createdAt;
  final int? studentCount;         // schema: Int?
  final double amount;
  final double? instituteCommission; // schema: Float?
  final String? location;          // schema: String?
  final int grade;
  // joined / computed fields
  final String subjectName;
  final String tutorName;
  final String? instituteName;     // nullable because institute_id is nullable
  final String duration;

  ClassModel({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.tutorId,
    this.instituteId,
    required this.startTime,
    required this.endTime,
    required this.day,
    this.description,
    required this.status,
    required this.createdAt,
    this.studentCount,
    required this.amount,
    this.instituteCommission,
    this.location,
    required this.grade,
    required this.subjectName,
    required this.tutorName,
    this.instituteName,
    required this.duration,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subjectId: json['subject_id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      instituteId: json['institute_id'] as String?,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      day: json['day'] ?? 0,
      description: json['description'] as String?,
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      studentCount: json['student_count'] as int?,
      amount: (json['amount'] ?? 0).toDouble(),
      instituteCommission: json['institute_commission'] != null
          ? (json['institute_commission']).toDouble()
          : null,
      location: json['location'] as String?,
      grade: json['grade'] ?? 0,
      subjectName: json['subject_name'] ?? '',
      tutorName: json['tutor_name'] ?? '',
      instituteName: json['institute_name'] as String?,
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "subject_id": subjectId,
      "tutor_id": tutorId,
      "institute_id": instituteId,
      "start_time": startTime,
      "end_time": endTime,
      "day": day,
      "description": description,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "student_count": studentCount,
      "amount": amount,
      "institute_commission": instituteCommission,
      "location": location,
      "grade": grade,
      "subject_name": subjectName,
      "tutor_name": tutorName,
      "institute_name": instituteName,
      "duration": duration,
    };
  }

  @override
  String toString() => toJson().toString();
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorClassPageController extends ChangeNotifier {
  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 4;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedDay;
  String? _selectedSubject;
  String? _selectedGrade;
  String? _selectedStatus;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? get selectedDay => _selectedDay;
  String? get selectedSubject => _selectedSubject;
  String? get selectedGrade => _selectedGrade;
  String? get selectedStatus => _selectedStatus;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;

  String? _timeError;
  String? get timeError => _timeError;

  // ── Source data ─────────────────────────────────────────────
  List<ClassModel> _allClasses = [];
  List<ClassModel> get allClasses => _allClasses;

  // ── Setters ──────────────────────────────────────────────────
  void setSubject(String? value) {
    _selectedSubject = value;
  }

  void setDay(String? value) {
    _selectedDay = value;
  }

  void setGrade(String? value) {
    _selectedGrade = value;
    notifyListeners();
  }

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
    _timeError =
        end <= start ? "End time must be after start time" : null;
  }

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedDay != null) count++;
    if (_selectedSubject != null) count++;
    if (_selectedGrade != null) count++;
    if (_selectedStatus != null) count++;
    if (_startTime != null || _endTime != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<ClassModel> get filteredClasses {
    return _allClasses.where((cls) {
      final matchesSearch = _searchQuery.isEmpty ||
          cls.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cls.subjectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (cls.instituteName ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesDay =
          _selectedDay == null || cls.day.toString() == _selectedDay;

      final matchesSubject =
          _selectedSubject == null || cls.subjectId == _selectedSubject;

      final matchesGrade =
          _selectedGrade == null || cls.grade.toString() == _selectedGrade;

      final matchesStatus = _selectedStatus == null ||
          cls.status.toUpperCase() == _selectedStatus!.toUpperCase();

      bool matchesTime = true;
      if (_startTime != null || _endTime != null) {
        try {
          final parts = cls.startTime.split(':');
          final classMinutes =
              int.parse(parts[0]) * 60 + int.parse(parts[1]);
          if (_startTime != null) {
            final filterStart =
                _startTime!.hour * 60 + _startTime!.minute;
            if (classMinutes < filterStart) matchesTime = false;
          }
          if (_endTime != null) {
            final filterEnd = _endTime!.hour * 60 + _endTime!.minute;
            if (classMinutes > filterEnd) matchesTime = false;
          }
        } catch (_) {
          matchesTime = true;
        }
      }

      return matchesSearch &&
          matchesDay &&
          matchesSubject &&
          matchesGrade &&
          matchesStatus &&
          matchesTime;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredClasses.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
  List<ClassModel> get currentPageItems {
    if (filteredClasses.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredClasses.length);
    return filteredClasses.sublist(start, end);
  }

  // ── Methods ──────────────────────────────────────────────────

  /// Load or replace the full class list (called from the page after fetch).
  void loadClasses(List<ClassModel> classes) {
    _allClasses = classes;
    _currentPage = 0;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 0 || page >= totalPages) return;
    _currentPage = page;
    notifyListeners();
  }

  void onSearchChanged(String value) {
    _searchQuery = value;
    _currentPage = 0;
    notifyListeners();
  }

  void applyFilters({
    String? day,
    String? subject,
    String? grade,
    String? status,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    _selectedDay = day;
    _selectedSubject = subject;
    _selectedGrade = grade;
    _selectedStatus = status;
    _startTime = startTime;
    _endTime = endTime;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDay = null;
    _selectedSubject = null;
    _selectedGrade = null;
    _selectedStatus = null;
    _startTime = null;
    _endTime = null;
    _currentPage = 0;
    notifyListeners();
  }
}
