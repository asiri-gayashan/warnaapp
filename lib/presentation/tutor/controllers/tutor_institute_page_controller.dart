import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';

// ============================================================
// MODEL
// ============================================================

class TutorInstituteModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String districtId;
  final String districtName;
  final String description;
  final String status;
  final int totalTutors;
  final int totalStudents;
  final int totalClasses;
  final int myClassCount;
  final int myStudentCount;

  const TutorInstituteModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.districtId,
    required this.districtName,
    required this.description,
    required this.status,
    required this.totalTutors,
    required this.totalStudents,
    required this.totalClasses,
    required this.myClassCount,
    required this.myStudentCount,
  });

  factory TutorInstituteModel.fromJson(Map<String, dynamic> json) {
    return TutorInstituteModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      districtId: json['district_id'] ?? '',
      districtName: json['district_name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'ACTIVE',
      totalTutors: json['total_tutors'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
      totalClasses: json['total_classes'] ?? 0,
      myClassCount: json['my_class_count'] ?? 0,
      myStudentCount: json['my_student_count'] ?? 0,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorInstitutePageController extends ChangeNotifier {
  final _dio = DioClient.instance;
  final _metadata = MetadataRepository();

  // ── Districts (for filter dropdown) ─────────────────────────
  List<Map<String, String>> _districts = [];
  List<Map<String, String>> get districts => _districts;

  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 6;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = ''; 
  String get searchQuery => _searchQuery;

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedDistrict;
  String? _selectedStatus;
  int? _minClasses;
  int? _maxClasses;

  String? get selectedDistrict => _selectedDistrict;
  String? get selectedStatus => _selectedStatus;
  int? get minClasses => _minClasses;
  int? get maxClasses => _maxClasses;

  // ── Source data ─────────────────────────────────────────────
  List<TutorInstituteModel> _allInstitutes = [];
  List<TutorInstituteModel> get allInstitutes => _allInstitutes;

  // ── Active filter count ──────────────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedDistrict != null) count++;
    if (_selectedStatus != null) count++;
    if (_minClasses != null || _maxClasses != null) count++;
    return count;
  }

  // ── Filtered list ─────────────────────────────────────────────
  List<TutorInstituteModel> get filteredInstitutes {
    return _allInstitutes.where((inst) {
      final matchesSearch = _searchQuery.isEmpty ||
          inst.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inst.districtName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          inst.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDistrict =
          _selectedDistrict == null || inst.districtId == _selectedDistrict;

      final matchesStatus = _selectedStatus == null ||
          inst.status.toUpperCase() == _selectedStatus!.toUpperCase();

      bool matchesClasses = true;
      if (_minClasses != null) matchesClasses = inst.myClassCount >= _minClasses!;
      if (matchesClasses && _maxClasses != null) {
        matchesClasses = inst.myClassCount <= _maxClasses!;
      }

      return matchesSearch && matchesDistrict && matchesStatus && matchesClasses;
    }).toList();
  }

  // ── Total pages ──────────────────────────────────────────────
  int get totalPages =>
      (filteredInstitutes.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Current page items ─────────────────────────────────────────
  List<TutorInstituteModel> get currentPageItems {
    if (filteredInstitutes.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredInstitutes.length);
    return filteredInstitutes.sublist(start, end);
  }

  // ── Fetch ────────────────────────────────────────────────────
  Future<bool> fetchInstitutes() async {
    try {
      final user = await UserService.getUser();

      final results = await Future.wait([
        _dio.get("/institutes/tutor/${user?["id"]}"),
        _metadata.getDistricts(),
      ]);

      final instituteResponse = results[0] as dynamic;
      final districtsRaw = results[1] as List<dynamic>?;

      if (districtsRaw != null) {
        _districts = districtsRaw
            .map((d) => {"id": d["id"].toString(), "name": d["name"].toString()})
            .toList();
      }

      if (instituteResponse.data['success'] == true &&
          instituteResponse.data['data'] != null) {
        final List<dynamic> data = instituteResponse.data['data'];
        _allInstitutes = data
            .map((json) => TutorInstituteModel.fromJson(json as Map<String, dynamic>))
            .toList();
        _currentPage = 0;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error fetching institutes: $e");
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
    String? district,
    String? status,
    int? minClasses,
    int? maxClasses,
  }) {
    _selectedDistrict = district;
    _selectedStatus = status;
    _minClasses = minClasses;
    _maxClasses = maxClasses;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDistrict = null;
    _selectedStatus = null;
    _minClasses = null;
    _maxClasses = null;
    _currentPage = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
