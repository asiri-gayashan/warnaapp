import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';

// ============================================================
// MODEL
// ============================================================

class StudentInstituteModel {
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

  const StudentInstituteModel({
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
  });

  factory StudentInstituteModel.fromJson(Map<String, dynamic> j) {
    return StudentInstituteModel(
      id: j['id']?.toString() ?? '',
      fullName: j['full_name']?.toString() ?? '',
      email: j['email']?.toString() ?? '',
      phone: j['phone']?.toString() ?? '',
      addressLine1: j['address_line1']?.toString() ?? '',
      addressLine2: j['address_line2']?.toString() ?? '',
      districtId: j['district_id']?.toString() ?? '',
      districtName: j['district_name']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      status: j['status']?.toString() ?? 'ACTIVE',
      totalTutors: (j['total_tutors'] as num?)?.toInt() ?? 0,
      totalStudents: (j['total_students'] as num?)?.toInt() ?? 0,
      totalClasses: (j['total_classes'] as num?)?.toInt() ?? 0,
      myClassCount: (j['my_class_count'] as num?)?.toInt() ?? 0,
    );
  }
}

const List<String> studentInstituteStatusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
];

// ============================================================
// CONTROLLER
// ============================================================

class StudentInstitutePageController extends ChangeNotifier {
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
  bool isLoading = false;
  List<StudentInstituteModel> _allInstitutes = [];
  List<StudentInstituteModel> get allInstitutes => _allInstitutes;

  // ── Fetch (real API) ─────────────────────────────────────────
  Future<void> fetchInstitutes() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];

      final results = await Future.wait([
        _dio.get('/student-dashboard/institutes/$studentUserId'),
        _metadata.getDistricts(),
      ]);

      final response = results[0] as dynamic;
      final districtsRaw = results[1] as List<dynamic>?;

      if (districtsRaw != null) {
        _districts = districtsRaw
            .map((d) => {
                  'id': d['id'].toString(),
                  'name': d['name'].toString(),
                })
            .toList();
      }

      final List<dynamic> raw = response.data is List
          ? List<dynamic>.from(response.data as List)
          : List<dynamic>.from((response.data['data'] as List?) ?? []);

      _allInstitutes = raw
          .map((j) => StudentInstituteModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching student institutes: $e');
      _allInstitutes = [];
    }
    _currentPage = 0;
    isLoading = false;
    notifyListeners();
  }

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedDistrict != null) count++;
    if (_selectedStatus != null) count++;
    if (_minClasses != null || _maxClasses != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<StudentInstituteModel> get filteredInstitutes {
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
      if (_minClasses != null) {
        matchesClasses = inst.myClassCount >= _minClasses!;
      }
      if (matchesClasses && _maxClasses != null) {
        matchesClasses = inst.myClassCount <= _maxClasses!;
      }

      return matchesSearch && matchesDistrict && matchesStatus && matchesClasses;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredInstitutes.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
  List<StudentInstituteModel> get currentPageItems {
    if (filteredInstitutes.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredInstitutes.length);
    return filteredInstitutes.sublist(start, end);
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
