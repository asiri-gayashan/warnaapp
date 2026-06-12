import 'package:flutter/material.dart';

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
}

// ============================================================
// DUMMY DISTRICTS (for filter dropdown)
// ============================================================

const List<Map<String, String>> tutorInstituteDistrictsList = [
  {"id": "1", "name": "Colombo"},
  {"id": "2", "name": "Gampaha"},
  {"id": "3", "name": "Kalutara"},
  {"id": "4", "name": "Kandy"},
  {"id": "5", "name": "Galle"},
  {"id": "6", "name": "Kurunegala"},
];

// ============================================================
// CONTROLLER
// ============================================================

class TutorInstitutePageController extends ChangeNotifier {
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

  // ── Fetch (dummy data) ────────────────────────────────────────
  Future<bool> fetchInstitutes() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _allInstitutes = const [
      TutorInstituteModel(
        id: 'inst-1',
        fullName: 'Bright Future Institute',
        email: 'info@brightfuture.lk',
        phone: '+94 11 234 5678',
        addressLine1: 'No. 120, Galle Road',
        addressLine2: 'Colombo 03',
        districtId: '1',
        districtName: 'Colombo',
        description:
            'A leading tuition institute offering classes for grades 6-13 across Mathematics, Science and English streams.',
        status: 'ACTIVE',
        totalTutors: 18,
        totalStudents: 420,
        totalClasses: 32,
        myClassCount: 4,
        myStudentCount: 73,
      ),
      TutorInstituteModel(
        id: 'inst-2',
        fullName: 'Star Academy',
        email: 'contact@staracademy.lk',
        phone: '+94 81 222 3344',
        addressLine1: 'No. 45, Peradeniya Road',
        addressLine2: 'Kandy',
        districtId: '4',
        districtName: 'Kandy',
        description:
            'A well-established academy specialising in O/L and A/L Science subjects with modern lab facilities.',
        status: 'ACTIVE',
        totalTutors: 12,
        totalStudents: 260,
        totalClasses: 20,
        myClassCount: 2,
        myStudentCount: 29,
      ),
      TutorInstituteModel(
        id: 'inst-3',
        fullName: 'Lyceum International Campus',
        email: 'admin@lyceumic.lk',
        phone: '+94 11 567 8901',
        addressLine1: 'No. 9, Park Road',
        addressLine2: 'Colombo 05',
        districtId: '1',
        districtName: 'Colombo',
        description:
            'International curriculum campus offering Cambridge and Edexcel programmes.',
        status: 'PENDING',
        totalTutors: 25,
        totalStudents: 600,
        totalClasses: 45,
        myClassCount: 0,
        myStudentCount: 0,
      ),
      TutorInstituteModel(
        id: 'inst-4',
        fullName: 'Horizon Campus',
        email: 'info@horizoncampus.lk',
        phone: '+94 11 789 0123',
        addressLine1: 'No. 78, Negombo Road',
        addressLine2: 'Wattala',
        districtId: '2',
        districtName: 'Gampaha',
        description:
            'A growing institute focused on technology and business education.',
        status: 'ACTIVE',
        totalTutors: 15,
        totalStudents: 310,
        totalClasses: 28,
        myClassCount: 0,
        myStudentCount: 0,
      ),
      TutorInstituteModel(
        id: 'inst-5',
        fullName: 'Elite Tuition Center',
        email: 'hello@elitetuition.lk',
        phone: '+94 91 345 6789',
        addressLine1: 'No. 34, Matara Road',
        addressLine2: 'Galle',
        districtId: '5',
        districtName: 'Galle',
        description: 'Southern province tuition center for grades 6-11.',
        status: 'INACTIVE',
        totalTutors: 8,
        totalStudents: 150,
        totalClasses: 14,
        myClassCount: 0,
        myStudentCount: 0,
      ),
      TutorInstituteModel(
        id: 'inst-6',
        fullName: 'Knowledge Hub Academy',
        email: 'support@knowledgehub.lk',
        phone: '+94 37 456 7890',
        addressLine1: 'No. 56, Kandy Road',
        addressLine2: 'Kurunegala',
        districtId: '6',
        districtName: 'Kurunegala',
        description:
            'North western province academy offering combined maths and science classes.',
        status: 'ACTIVE',
        totalTutors: 10,
        totalStudents: 200,
        totalClasses: 18,
        myClassCount: 0,
        myStudentCount: 0,
      ),
      TutorInstituteModel(
        id: 'inst-7',
        fullName: 'Pinnacle Academy',
        email: 'info@pinnacle.lk',
        phone: '+94 34 567 1234',
        addressLine1: 'No. 11, Station Road',
        addressLine2: 'Kalutara',
        districtId: '3',
        districtName: 'Kalutara',
        description:
            'Newly established academy for primary and secondary education.',
        status: 'PENDING',
        totalTutors: 6,
        totalStudents: 95,
        totalClasses: 9,
        myClassCount: 0,
        myStudentCount: 0,
      ),
    ];

    _currentPage = 0;
    notifyListeners();
    return true;
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
