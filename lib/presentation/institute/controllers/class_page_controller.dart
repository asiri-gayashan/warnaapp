import 'package:flutter/material.dart';

// ============================================================
// DATA MODEL
// ============================================================

class CourseData {
  final String title;
  final String subject;
  final String grade;
  final String location;
  final String day;
  final String time;
  final String duration;
  final int studentCount;
  final Color dayColor;
  final Color dayBg;

  const CourseData({
    required this.title,
    required this.subject,
    required this.grade,
    required this.location,
    required this.day,
    required this.time,
    required this.duration,
    required this.studentCount,
    required this.dayColor,
    required this.dayBg,
  });
}

// ============================================================
// CLASS PAGE CONTROLLER
// ============================================================

class ClassPageController extends ChangeNotifier {
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

  // ── Source data (in a real app, fetched from API/repo) ───────
  List<CourseData> _allCourses = [];

  List<CourseData> get allCourses => _allCourses;

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
  List<CourseData> get filteredCourses {
    return _allCourses.where((course) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.subject.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDay =
          _selectedDay == null ||
          course.day.toLowerCase() == _selectedDay!.toLowerCase();

      final matchesSubject =
          _selectedSubject == null ||
          course.subject.toLowerCase() == _selectedSubject!.toLowerCase();

      final matchesGrade =
          _selectedGrade == null ||
          course.grade.toLowerCase().replaceAll(' ', '_') ==
              _selectedGrade!.toLowerCase();

      return matchesSearch && matchesDay && matchesSubject && matchesGrade;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredCourses.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
  List<CourseData> get currentPageItems {
    if (filteredCourses.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredCourses.length);
    return filteredCourses.sublist(start, end);
  }

  // ── Methods ──────────────────────────────────────────────────

  /// Load or replace the full course list (e.g., after an API call).
  void loadCourses(List<CourseData> courses) {
    _allCourses = courses;
    _currentPage = 0;
    notifyListeners();
  }

  /// Navigate to a specific page index.
  void goToPage(int page) {
    if (page < 0 || page >= totalPages) return;
    _currentPage = page;
    notifyListeners();
  }

  /// Update the search query and reset to page 0.
  void onSearchChanged(String value) {
    _searchQuery = value;
    _currentPage = 0;
    notifyListeners();
  }

  /// Apply a full set of filters at once (called from the filter sheet).
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

  /// Clear every active filter.
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

  @override
  void dispose() {
    super.dispose();
  }
}