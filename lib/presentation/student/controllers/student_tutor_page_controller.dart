import 'package:flutter/material.dart';

// ============================================================
// MODEL
// ============================================================

class StudentTutorModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String description;
  final String districtId;
  final String districtName;
  final List<String> subjects;
  final int experience;
  final String status;
  final int myClassCount;

  const StudentTutorModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.description,
    required this.districtId,
    required this.districtName,
    required this.subjects,
    required this.experience,
    required this.status,
    required this.myClassCount,
  });
}

// ============================================================
// CANONICAL DUMMY DATA
// ============================================================

final List<StudentTutorModel> studentDummyTutors = [
  const StudentTutorModel(
    id: 't1',
    fullName: 'Nuwan Perera',
    email: 'nuwan.perera@example.com',
    phone: '0771234567',
    addressLine1: 'No. 12, Galle Road',
    addressLine2: 'Colombo 03',
    description:
        'Experienced Mathematics and ICT tutor with a focus on A/L exam '
        'preparation and structured problem-solving techniques.',
    districtId: '1',
    districtName: 'Colombo',
    subjects: ['Mathematics', 'ICT'],
    experience: 8,
    status: 'ACTIVE',
    myClassCount: 2,
  ),
  const StudentTutorModel(
    id: 't2',
    fullName: 'Saman Kumara',
    email: 'saman.kumara@example.com',
    phone: '0772345678',
    addressLine1: 'No. 45, Negombo Road',
    addressLine2: 'Gampaha',
    description:
        'Physics tutor specializing in mechanics and electromagnetism, '
        'with engaging hands-on practical demonstrations.',
    districtId: '4',
    districtName: 'Gampaha',
    subjects: ['Physics'],
    experience: 10,
    status: 'ACTIVE',
    myClassCount: 1,
  ),
  const StudentTutorModel(
    id: 't3',
    fullName: 'Dilani Fernando',
    email: 'dilani.fernando@example.com',
    phone: '0773456789',
    addressLine1: 'No. 7, Peradeniya Road',
    addressLine2: 'Kandy',
    description:
        'Chemistry tutor with a strong focus on organic chemistry and '
        'practical laboratory skills for A/L students.',
    districtId: '8',
    districtName: 'Kandy',
    subjects: ['Chemistry'],
    experience: 6,
    status: 'ACTIVE',
    myClassCount: 1,
  ),
  const StudentTutorModel(
    id: 't4',
    fullName: 'Anjali Silva',
    email: 'anjali.silva@example.com',
    phone: '0774567890',
    addressLine1: 'No. 23, Havelock Road',
    addressLine2: 'Colombo 05',
    description:
        'English Literature tutor passionate about critical analysis, '
        'essay writing and exam preparation strategies.',
    districtId: '1',
    districtName: 'Colombo',
    subjects: ['English'],
    experience: 5,
    status: 'ACTIVE',
    myClassCount: 1,
  ),
  const StudentTutorModel(
    id: 't5',
    fullName: 'Kasun Jayawardena',
    email: 'kasun.jayawardena@example.com',
    phone: '0775678901',
    addressLine1: 'No. 56, Matara Road',
    addressLine2: 'Galle',
    description:
        'Biology tutor focused on building strong foundations in cell '
        'biology, genetics and human physiology.',
    districtId: '12',
    districtName: 'Galle',
    subjects: ['Biology'],
    experience: 7,
    status: 'ACTIVE',
    myClassCount: 1,
  ),
];

const List<Map<String, String>> studentTutorSubjectOptions = [
  {'id': 'Mathematics', 'name': 'Mathematics'},
  {'id': 'Physics', 'name': 'Physics'},
  {'id': 'Chemistry', 'name': 'Chemistry'},
  {'id': 'English', 'name': 'English'},
  {'id': 'ICT', 'name': 'ICT'},
  {'id': 'Biology', 'name': 'Biology'},
];

// ============================================================
// CONTROLLER
// ============================================================

class StudentTutorPageController extends ChangeNotifier {
  // ── Pagination ──────────────────────────────────────────────
  static const int itemsPerPage = 6;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // ── Search ──────────────────────────────────────────────────
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // ── Filters ─────────────────────────────────────────────────
  String? _selectedSubject;
  int? _minExperience;
  int? _maxExperience;

  String? get selectedSubject => _selectedSubject;
  int? get minExperience => _minExperience;
  int? get maxExperience => _maxExperience;

  // ── Source data ─────────────────────────────────────────────
  bool isLoading = false;
  List<StudentTutorModel> _allTutors = [];
  List<StudentTutorModel> get allTutors => _allTutors;

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchTutors() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _allTutors = studentDummyTutors;

    isLoading = false;
    notifyListeners();
  }

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedSubject != null) count++;
    if (_minExperience != null || _maxExperience != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<StudentTutorModel> get filteredTutors {
    return _allTutors.where((tutor) {
      final matchesSearch = _searchQuery.isEmpty ||
          tutor.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tutor.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tutor.subjects.any(
            (s) => s.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      final matchesSubject =
          _selectedSubject == null || tutor.subjects.contains(_selectedSubject);

      bool matchesExperience = true;
      if (_minExperience != null) {
        matchesExperience = tutor.experience >= _minExperience!;
      }
      if (matchesExperience && _maxExperience != null) {
        matchesExperience = tutor.experience <= _maxExperience!;
      }

      return matchesSearch && matchesSubject && matchesExperience;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredTutors.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
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
    int? minExperience,
    int? maxExperience,
  }) {
    _selectedSubject = subject;
    _minExperience = minExperience;
    _maxExperience = maxExperience;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSubject = null;
    _minExperience = null;
    _maxExperience = null;
    _currentPage = 0;
    notifyListeners();
  }
}
