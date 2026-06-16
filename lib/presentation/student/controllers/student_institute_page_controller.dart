import 'package:flutter/material.dart';

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
}

// ============================================================
// CANONICAL DUMMY DATA
// ============================================================

final List<StudentInstituteModel> studentDummyInstitutes = [
  const StudentInstituteModel(
    id: 'i1',
    fullName: 'Bright Future Institute',
    email: 'info@brightfuture.lk',
    phone: '0112345678',
    addressLine1: 'No. 25, Duplication Road',
    addressLine2: 'Colombo 03',
    districtId: '1',
    districtName: 'Colombo',
    description:
        'Bright Future Institute is a premier educational centre offering '
        'quality tuition for A/L students across a wide range of subjects.',
    status: 'ACTIVE',
    totalTutors: 18,
    totalStudents: 240,
    totalClasses: 32,
    myClassCount: 2,
  ),
  const StudentInstituteModel(
    id: 'i2',
    fullName: 'Star Academy',
    email: 'contact@staracademy.lk',
    phone: '0812345678',
    addressLine1: 'No. 12, Peradeniya Road',
    addressLine2: 'Kandy',
    districtId: '8',
    districtName: 'Kandy',
    description:
        'Star Academy provides comprehensive A/L tuition with dedicated '
        'faculty and a student-friendly learning environment in Kandy.',
    status: 'ACTIVE',
    totalTutors: 14,
    totalStudents: 180,
    totalClasses: 24,
    myClassCount: 2,
  ),
  const StudentInstituteModel(
    id: 'i3',
    fullName: 'Horizon Campus',
    email: 'hello@horizoncampus.lk',
    phone: '0332345678',
    addressLine1: 'No. 67, Negombo Road',
    addressLine2: 'Gampaha',
    districtId: '4',
    districtName: 'Gampaha',
    description:
        'Horizon Campus specialises in ICT and science subjects, equipping '
        'students with practical skills for the modern world.',
    status: 'ACTIVE',
    totalTutors: 10,
    totalStudents: 130,
    totalClasses: 16,
    myClassCount: 1,
  ),
];

const List<Map<String, String>> studentInstituteDistrictOptions = [
  {'id': '1', 'name': 'Colombo'},
  {'id': '4', 'name': 'Gampaha'},
  {'id': '8', 'name': 'Kandy'},
];

const List<String> studentInstituteStatusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
];

// ============================================================
// CONTROLLER
// ============================================================

class StudentInstitutePageController extends ChangeNotifier {
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

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchInstitutes() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _allInstitutes = studentDummyInstitutes;

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
}
