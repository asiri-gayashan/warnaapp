import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// STUDENT MODEL
// ============================================================

class TutorStudentModel {
  final String id;
  final String userId;
  final DateTime dob;
  final int age;
  final String school;
  final int grade;
  final DateTime createdAt;

  // User fields
  final String fullName;
  final String email;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String description;
  final String districtId;
  final String districtName;
  final String status;
  final String role;

  TutorStudentModel({
    required this.id,
    required this.userId,
    required this.dob,
    required this.age,
    required this.school,
    required this.grade,
    required this.createdAt,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.description,
    required this.districtId,
    required this.districtName,
    required this.status,
    required this.role,
  });

  factory TutorStudentModel.fromJson(Map<String, dynamic> json) {
    return TutorStudentModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      dob: json['dob'] != null
          ? DateTime.parse(json['dob'])
          : DateTime.now(),
      age: json['age'] ?? 0,
      school: json['school'] ?? '',
      grade: json['grade'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      fullName: json['users']?['full_name'] ?? '',
      email: json['users']?['email'] ?? '',
      phone: json['users']?['phone'] ?? '',
      addressLine1: json['users']?['address_line1'] ?? '',
      addressLine2: json['users']?['address_line2'] ?? '',
      description: json['users']?['description'] ?? '',
      districtId: json['users']?['district_id'] ?? '',
      districtName: json['users']?['district']?['name'] ?? '',
      status: json['users']?['status'] ?? 'INACTIVE',
      role: json['users']?['role'] ?? 'STUDENT',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'dob': dob.toIso8601String(),
      'age': age,
      'school': school,
      'grade': grade,
      'created_at': createdAt.toIso8601String(),
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'description': description,
      'district_id': districtId,
      'district_name': districtName,
      'status': status,
      'role': role,
    };
  }
}

// ============================================================
// STUDENT PAGE CONTROLLER
// ============================================================

class TutorStudentPageController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 6;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedStatus;
  String? _selectedGrade;
  int? _minAge;
  int? _maxAge;

  String? get selectedStatus => _selectedStatus;
  String? get selectedGrade => _selectedGrade;
  int? get minAge => _minAge;
  int? get maxAge => _maxAge;

  // ── Source data ─────────────────────────────────────────────
  List<TutorStudentModel> _allStudents = [];
  List<TutorStudentModel> get allStudents => _allStudents;

  // ── Active filter count ──────────────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedStatus != null) count++;
    if (_selectedGrade != null) count++;
    if (_minAge != null || _maxAge != null) count++;
    return count;
  }

  // ── Filtered list ────────────────────────────────────────────
  List<TutorStudentModel> get filteredStudents {
    return _allStudents.where((student) {
      final matchesSearch = _searchQuery.isEmpty ||
          student.fullName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.email
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.school
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatus == null ||
          student.status.toUpperCase() == _selectedStatus!.toUpperCase();

      final matchesGrade = _selectedGrade == null ||
          student.grade.toString() == _selectedGrade;

      bool matchesAge = true;
      if (_minAge != null) matchesAge = student.age >= _minAge!;
      if (matchesAge && _maxAge != null) matchesAge = student.age <= _maxAge!;

      return matchesSearch && matchesStatus && matchesGrade && matchesAge;
    }).toList();
  }

  // ── Total pages ──────────────────────────────────────────────
  int get totalPages =>
      (filteredStudents.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Current page items ───────────────────────────────────────
  List<TutorStudentModel> get currentPageItems {
    if (filteredStudents.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredStudents.length);
    return filteredStudents.sublist(start, end);
  }

  // ── Fetch ────────────────────────────────────────────────────
  Future<bool> fetchStudents() async {
    try {
      final user = await UserService.getUser();
      final response = await _dio.get("/students/tutor/${user?["id"]}");

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        _allStudents = data
            .map((json) => TutorStudentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        _currentPage = 0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error fetching students: $e");
      return false;
    }
  }

  // ── Navigation ───────────────────────────────────────────────

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
    String? status,
    String? grade,
    int? minAge,
    int? maxAge,
  }) {
    _selectedStatus = status;
    _selectedGrade = grade;
    _minAge = minAge;
    _maxAge = maxAge;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedStatus = null;
    _selectedGrade = null;
    _minAge = null;
    _maxAge = null;
    _currentPage = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
