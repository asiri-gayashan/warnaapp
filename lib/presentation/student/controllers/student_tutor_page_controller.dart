import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// MODEL
// ============================================================

class StudentTutorModel {
  final String id;       // tutor record id
  final String userId;   // user id (matches StudentClassModel.tutorId)
  final String fullName;
  final String email;
  final String phone;
  final String description;
  final String districtId;
  final String districtName;
  final String subjectId;
  final String subjectName;
  final int experience;
  final dynamic ratings;
  final int myClassCount;

  const StudentTutorModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.description,
    required this.districtId,
    required this.districtName,
    required this.subjectId,
    required this.subjectName,
    required this.experience,
    required this.ratings,
    required this.myClassCount,
  });

  // For backward compat with detail page (subjects list)
  List<String> get subjects =>
      subjectName.isNotEmpty ? [subjectName] : [];

  factory StudentTutorModel.fromJson(Map<String, dynamic> j) {
    return StudentTutorModel(
      id: j['id']?.toString() ?? '',
      userId: j['user_id']?.toString() ?? '',
      fullName: j['full_name']?.toString() ?? '',
      email: j['email']?.toString() ?? '',
      phone: j['phone']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      districtId: j['district_id']?.toString() ?? '',
      districtName: j['district_name']?.toString() ?? '',
      subjectId: j['subject_id']?.toString() ?? '',
      subjectName: j['subject_name']?.toString() ?? '',
      experience: (j['experience'] as num?)?.toInt() ?? 0,
      ratings: j['ratings'],
      myClassCount: (j['my_class_count'] as num?)?.toInt() ?? 0,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentTutorPageController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 6;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = '';

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedSubject;
  String? _selectedDistrict;
  int? _minExperience;
  int? _maxExperience;

  String? get selectedSubject => _selectedSubject;
  String? get selectedDistrict => _selectedDistrict;
  int? get minExperience => _minExperience;
  int? get maxExperience => _maxExperience;

  // ── Source data ─────────────────────────────────────────────
  bool isLoading = false;
  List<StudentTutorModel> _allTutors = [];

  // ── Fetch (real API) ─────────────────────────────────────────
  Future<void> fetchTutors() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final response = await _dio.get('/student-dashboard/tutors/$studentUserId');
      final List<dynamic> raw = response.data is List
          ? List<dynamic>.from(response.data as List)
          : List<dynamic>.from((response.data['data'] as List?) ?? []);
      _allTutors = raw
          .map((j) => StudentTutorModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching student tutors: $e');
      _allTutors = [];
    }
    _currentPage = 0;
    isLoading = false;
    notifyListeners();
  }

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedSubject != null) count++;
    if (_selectedDistrict != null) count++;
    if (_minExperience != null || _maxExperience != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<StudentTutorModel> get filteredTutors {
    return _allTutors.where((tutor) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          tutor.fullName.toLowerCase().contains(q) ||
          tutor.email.toLowerCase().contains(q) ||
          tutor.subjectName.toLowerCase().contains(q);

      final matchesSubject =
          _selectedSubject == null || tutor.subjectId == _selectedSubject;

      final matchesDistrict =
          _selectedDistrict == null || tutor.districtId == _selectedDistrict;

      bool matchesExperience = true;
      if (_minExperience != null) {
        matchesExperience = tutor.experience >= _minExperience!;
      }
      if (matchesExperience && _maxExperience != null) {
        matchesExperience = tutor.experience <= _maxExperience!;
      }

      return matchesSearch && matchesSubject && matchesDistrict && matchesExperience;
    }).toList();
  }

  // ── Pagination ───────────────────────────────────────────────
  int get totalPages =>
      (filteredTutors.length / itemsPerPage).ceil().clamp(1, 999);

  List<StudentTutorModel> get currentPageItems {
    if (filteredTutors.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredTutors.length);
    return filteredTutors.sublist(start, end);
  }

  // ── Methods ──────────────────────────────────────────────────
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
    String? subject,
    String? district,
    int? minExperience,
    int? maxExperience,
  }) {
    _selectedSubject = subject;
    _selectedDistrict = district;
    _minExperience = minExperience;
    _maxExperience = maxExperience;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSubject = null;
    _selectedDistrict = null;
    _minExperience = null;
    _maxExperience = null;
    _currentPage = 0;
    notifyListeners();
  }
}
