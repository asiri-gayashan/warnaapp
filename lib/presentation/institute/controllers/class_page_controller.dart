import 'package:flutter/material.dart';
import 'package:warna_app/data/models/class_model.dart';

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
    if (end <= start) {
      _timeError = "End time must be after start time";
    } else {
      _timeError = null;
    }
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
      // Search: match name or subject name
      final matchesSearch =
          _searchQuery.isEmpty ||
          cls.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cls.subjectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
           cls.tutorName.toLowerCase().contains(_searchQuery.toLowerCase());

      // Day filter: compare day int to selected id string (e.g. "1" == cls.day)
      final matchesDay =
          _selectedDay == null ||
          cls.day.toString() == _selectedDay;

      // Subject filter: compare subjectId to selected id
      final matchesSubject =
          _selectedSubject == null ||
          cls.subjectId == _selectedSubject;

      // Grade filter: compare grade int to selected id string (e.g. "11" == cls.grade)
      final matchesGrade =
          _selectedGrade == null ||
          cls.grade.toString() == _selectedGrade;

      // Status filter: compare status string
      final matchesStatus =
          _selectedStatus == null ||
          cls.status.toUpperCase() == _selectedStatus!.toUpperCase();

      // Time filter: class startTime (HH:mm) must be within range
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
            final filterEnd =
                _endTime!.hour * 60 + _endTime!.minute;
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

  /// Load or replace the full class list (called after API fetch).
  void loadClasses(List<ClassModel> classes) {
    _allClasses = classes;
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