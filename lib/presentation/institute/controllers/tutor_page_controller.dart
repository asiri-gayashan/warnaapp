import 'package:flutter/material.dart';
import 'package:warna_app/core/utils/user_service.dart';
import '../../../core/network/dio_client.dart';

// ============================================================
// TUTOR MODEL (Internal)
// ============================================================

class TutorModel {
  final String id;
  final String userId;
  final String subjectId;
  final String subjectName;
  final bool isIndependent;
  final dynamic ratings;
  final dynamic qualifications;
  final DateTime createdAt;
  final int studentCount;
  final int classCount;
  final int experience;
  final DateTime dob;
  final int age;

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

  TutorModel({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.subjectName,
    required this.isIndependent,
    required this.ratings,
    required this.qualifications,
    required this.createdAt,
    required this.studentCount,
    required this.classCount,
    required this.experience,
    required this.dob,
    required this.age,
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

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      subjectId: json['subject_id'] ?? '',
      subjectName: json['subject']?['name'] ?? '',
      isIndependent: json['is_independent'] ?? false,
      ratings: json['ratings'],
      qualifications: json['qualifications'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      studentCount: json['student_count'] ?? 0,
      classCount: json['class_count'] ?? 0,
      experience: json['experience'] ?? 0,
      dob: json['dob'] != null
          ? DateTime.parse(json['dob'])
          : DateTime.now(),
      age: json['age'] ?? 0,
      fullName: json['users']?['full_name'] ?? '',
      email: json['users']?['email'] ?? '',
      phone: json['users']?['phone'] ?? '',
      addressLine1: json['users']?['address_line1'] ?? '',
      addressLine2: json['users']?['address_line2'] ?? '',
      description: json['users']?['description'] ?? '',
      districtId: json['users']?['district_id'] ?? '',
      districtName: json['users']?['district']?['name'] ?? '',
      status: json['users']?['status'] ?? 'INACTIVE',
      role: json['users']?['role'] ?? 'TUTOR',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'is_independent': isIndependent,
      'ratings': ratings,
      'qualifications': qualifications,
      'created_at': createdAt.toIso8601String(),
      'student_count': studentCount,
      'class_count': classCount,
      'experience': experience,
      'dob': dob.toIso8601String(),
      'age': age,
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
// TUTOR PAGE CONTROLLER
// ============================================================

class TutorPageController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 6;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedSubject;
  String? _selectedDistrict;
  String? _selectedStatus;
  String? _selectedGrade;
  int? _minStudentCount;
  int? _maxStudentCount;
  int? _minClassCount;
  int? _maxClassCount;

  String? get selectedSubject => _selectedSubject;
  String? get selectedDistrict => _selectedDistrict;
  String? get selectedStatus => _selectedStatus;
  String? get selectedGrade => _selectedGrade;
  int? get minStudentCount => _minStudentCount;
  int? get maxStudentCount => _maxStudentCount;
  int? get minClassCount => _minClassCount;
  int? get maxClassCount => _maxClassCount;

  // ── Source data ─────────────────────────────────────────────
  List<TutorModel> _allTutors = [];
  List<TutorModel> get allTutors => _allTutors;

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedSubject != null) count++;
    if (_selectedDistrict != null) count++;
    if (_selectedStatus != null) count++;
    if (_selectedGrade != null) count++;
    if (_minStudentCount != null || _maxStudentCount != null) count++;
    if (_minClassCount != null || _maxClassCount != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<TutorModel> get filteredTutors {
    return _allTutors.where((tutor) {
      final matchesSearch = _searchQuery.isEmpty ||
          tutor.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tutor.subjectName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          tutor.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesSubject =
          _selectedSubject == null || tutor.subjectId == _selectedSubject;

      final matchesDistrict =
          _selectedDistrict == null || tutor.districtId == _selectedDistrict;

      final matchesStatus = _selectedStatus == null ||
          tutor.status.toUpperCase() == _selectedStatus!.toUpperCase();

      // Grade filter — extend TutorModel with a gradeId field when your API
      // supports it; for now we leave it as a pass-through (always true).
      final matchesGrade = _selectedGrade == null;

      bool matchesStudentCount = true;
      if (_minStudentCount != null) {
        matchesStudentCount = tutor.studentCount >= _minStudentCount!;
      }
      if (matchesStudentCount && _maxStudentCount != null) {
        matchesStudentCount = tutor.studentCount <= _maxStudentCount!;
      }

      bool matchesClassCount = true;
      if (_minClassCount != null) {
        matchesClassCount = tutor.classCount >= _minClassCount!;
      }
      if (matchesClassCount && _maxClassCount != null) {
        matchesClassCount = tutor.classCount <= _maxClassCount!;
      }

      return matchesSearch &&
          matchesSubject &&
          matchesDistrict &&
          matchesStatus &&
          matchesGrade &&
          matchesStudentCount &&
          matchesClassCount;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredTutors.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
  List<TutorModel> get currentPageItems {
    if (filteredTutors.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredTutors.length);
    return filteredTutors.sublist(start, end);
  }

  // ── API Methods ──────────────────────────────────────────────

  Future<bool> fetchTutors() async {
    try {
      final user = await UserService.getUser();

      final response = await _dio.get("/teachers/institute/${user?["id"]}");
      debugPrint("Fetch Tutors Response: ${response.data}");

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> tutorsData = response.data['data'];
        _allTutors = tutorsData
            .map((json) => TutorModel.fromJson(json as Map<String, dynamic>))
            .toList();
        _currentPage = 0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error fetching tutors: $e");
      return false;
    }
  }

  Future<TutorModel?> fetchTutorById(String id) async {
    try {
      final response = await _dio.get("/teachers/$id");
      if (response.data['status'] == true && response.data['data'] != null) {
        return TutorModel.fromJson(
            response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching tutor by ID: $e");
      return null;
    }
  }

  Future<TutorModel?> fetchTutorByEmail(String email) async {
    try {
      final response = await _dio.get("/teachers/email/$email");
      if (response.data['status'] == true && response.data['data'] != null) {
        return TutorModel.fromJson(
            response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching tutor by email: $e");
      return null;
    }
  }

  Future<bool> updateTutor(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put("/teachers/$id", data: data);
      if (response.data['status'] == true) {
        await fetchTutors();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating tutor: $e");
      return false;
    }
  }

  Future<bool> deleteTutor(String id) async {
    try {
      final response = await _dio.delete("/teachers/$id");
      if (response.data['status'] == true) {
        _allTutors.removeWhere((tutor) => tutor.id == id);
        _currentPage = 0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting tutor: $e");
      return false;
    }
  }

  // ── Navigation ──────────────────────────────────────────────

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

  void setGrade(String? gradeId) {
    _selectedGrade = gradeId;
    _currentPage = 0;
    notifyListeners();
  }

  void applyFilters({
    String? subject,
    String? district,
    String? status,
    String? grade,
    int? minStudentCount,
    int? maxStudentCount,
    int? minClassCount,
    int? maxClassCount,
  }) {
    _selectedSubject = subject;
    _selectedDistrict = district;
    _selectedStatus = status;
    _selectedGrade = grade;
    _minStudentCount = minStudentCount;
    _maxStudentCount = maxStudentCount;
    _minClassCount = minClassCount;
    _maxClassCount = maxClassCount;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSubject = null;
    _selectedDistrict = null;
    _selectedStatus = null;
    _selectedGrade = null;
    _minStudentCount = null;
    _maxStudentCount = null;
    _minClassCount = null;
    _maxClassCount = null;
    _currentPage = 0;
    notifyListeners();
  }

  void loadTutors(List<TutorModel> tutors) {
    _allTutors = tutors;
    _currentPage = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}