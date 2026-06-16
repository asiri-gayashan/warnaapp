import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';

// ============================================================
// MODEL
// ============================================================

class StudentClassModel {
  final String id;
  final String name;
  final String subjectId;
  final String subjectName;
  final int grade;
  final int day;
  final String startTime;
  final String endTime;
  final String duration;
  final String location;
  final String description;
  final double amount;
  final String status;
  final String tutorId;
  final String tutorName;
  final String tutorSubject;
  final String? instituteId;
  final String? instituteName;
  final int attendancePercentage;
  final String paymentStatus;
  final int classSize;

  const StudentClassModel({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.subjectName,
    required this.grade,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.location,
    required this.description,
    required this.amount,
    required this.status,
    required this.tutorId,
    required this.tutorName,
    required this.tutorSubject,
    this.instituteId,
    this.instituteName,
    required this.attendancePercentage,
    required this.paymentStatus,
    required this.classSize,
  });
}

// ============================================================
// CANONICAL DUMMY DATA
// ============================================================

final List<StudentClassModel> studentDummyClasses = [
  const StudentClassModel(
    id: 'c1',
    name: 'Combined Mathematics',
    subjectId: '1',
    subjectName: 'Combined Mathematics',
    grade: 12,
    day: 1,
    startTime: '14:00',
    endTime: '16:00',
    duration: '2h',
    location: 'Bright Future Institute - Room 101',
    description:
        'Comprehensive coverage of the Combined Mathematics syllabus for Grade 12, '
        'focusing on pure and applied mathematics with past paper practice.',
    amount: 4500,
    status: 'ACTIVE',
    tutorId: 't1',
    tutorName: 'Nuwan Perera',
    tutorSubject: 'Mathematics',
    instituteId: 'i1',
    instituteName: 'Bright Future Institute',
    attendancePercentage: 92,
    paymentStatus: 'PAID',
    classSize: 35,
  ),
  const StudentClassModel(
    id: 'c2',
    name: 'Physics for A/L',
    subjectId: '2',
    subjectName: 'Physics',
    grade: 12,
    day: 1,
    startTime: '16:00',
    endTime: '18:00',
    duration: '2h',
    location: 'Bright Future Institute - Room 203',
    description:
        'In-depth A/L Physics lessons covering mechanics, electricity and modern '
        'physics with practical demonstrations.',
    amount: 4000,
    status: 'ACTIVE',
    tutorId: 't2',
    tutorName: 'Saman Kumara',
    tutorSubject: 'Physics',
    instituteId: 'i1',
    instituteName: 'Bright Future Institute',
    attendancePercentage: 85,
    paymentStatus: 'PAID',
    classSize: 30,
  ),
  const StudentClassModel(
    id: 'c3',
    name: 'Chemistry Essentials',
    subjectId: '3',
    subjectName: 'Chemistry',
    grade: 12,
    day: 3,
    startTime: '14:00',
    endTime: '16:00',
    duration: '2h',
    location: 'Star Academy - Lab 1',
    description:
        'Essential Chemistry concepts for A/L students with emphasis on organic '
        'chemistry and lab techniques.',
    amount: 3500,
    status: 'ACTIVE',
    tutorId: 't3',
    tutorName: 'Dilani Fernando',
    tutorSubject: 'Chemistry',
    instituteId: 'i2',
    instituteName: 'Star Academy',
    attendancePercentage: 76,
    paymentStatus: 'PENDING',
    classSize: 28,
  ),
  const StudentClassModel(
    id: 'c4',
    name: 'English Literature',
    subjectId: '4',
    subjectName: 'English Literature',
    grade: 12,
    day: 3,
    startTime: '16:00',
    endTime: '17:30',
    duration: '1h 30m',
    location: 'Star Academy - Room 5',
    description:
        'Critical analysis of prescribed English Literature texts with essay '
        'writing and exam preparation.',
    amount: 3000,
    status: 'ACTIVE',
    tutorId: 't4',
    tutorName: 'Anjali Silva',
    tutorSubject: 'English',
    instituteId: 'i2',
    instituteName: 'Star Academy',
    attendancePercentage: 95,
    paymentStatus: 'PAID',
    classSize: 22,
  ),
  const StudentClassModel(
    id: 'c5',
    name: 'ICT Practical',
    subjectId: '5',
    subjectName: 'Information & Communication Technology (ICT)',
    grade: 12,
    day: 5,
    startTime: '09:00',
    endTime: '11:00',
    duration: '2h',
    location: 'Horizon Campus - Computer Lab',
    description:
        'Hands-on ICT practical sessions covering databases, programming basics '
        'and web development for A/L.',
    amount: 2800,
    status: 'ACTIVE',
    tutorId: 't1',
    tutorName: 'Nuwan Perera',
    tutorSubject: 'ICT',
    instituteId: 'i3',
    instituteName: 'Horizon Campus',
    attendancePercentage: 60,
    paymentStatus: 'PENDING',
    classSize: 18,
  ),
  const StudentClassModel(
    id: 'c6',
    name: 'Biology Foundations',
    subjectId: '6',
    subjectName: 'Biology',
    grade: 12,
    day: 5,
    startTime: '11:00',
    endTime: '13:00',
    duration: '2h',
    location: 'No. 45, Galle Road, Colombo 06',
    description:
        'Foundational Biology lessons covering cell biology, genetics and human '
        'physiology for A/L students.',
    amount: 3200,
    status: 'ACTIVE',
    tutorId: 't5',
    tutorName: 'Kasun Jayawardena',
    tutorSubject: 'Biology',
    instituteId: null,
    instituteName: null,
    attendancePercentage: 88,
    paymentStatus: 'PAID',
    classSize: 32,
  ),
];

const List<Map<String, String>> studentSubjectOptions = [
  {'id': '1', 'name': 'Combined Mathematics'},
  {'id': '2', 'name': 'Physics'},
  {'id': '3', 'name': 'Chemistry'},
  {'id': '4', 'name': 'English Literature'},
  {'id': '5', 'name': 'Information & Communication Technology (ICT)'},
  {'id': '6', 'name': 'Biology'},
];

const List<String> studentClassStatusOptions = ['ACTIVE', 'COMPLETED'];

// ============================================================
// HELPERS
// ============================================================

String studentDayName(int day) {
  try {
    return SelectOptions.days
            .firstWhere((e) => e['id'] == day.toString())['name'] ??
        '';
  } catch (_) {
    return '';
  }
}

String studentGradeName(int grade) {
  try {
    return SelectOptions.newgradesList
            .firstWhere((e) => e['id'] == grade.toString())['name'] ??
        '';
  } catch (_) {
    return '';
  }
}

Color studentDayColor(int day) {
  const colors = [
    Color(0xff185FA5),
    Color(0xff0F6E56),
    Color(0xff993C1D),
    Color(0xff7B3FA0),
    Color(0xff1A7A4A),
    Color(0xffB5500B),
    Color(0xff185FA5),
  ];
  return colors[day % colors.length];
}

Color studentDayBg(int day) {
  const bgs = [
    Color(0xffE8F2FF),
    Color(0xffE1F5EE),
    Color(0xffFAECE7),
    Color(0xffF3E8FF),
    Color(0xffE2F5EC),
    Color(0xffFFF0E0),
    Color(0xffE8F2FF),
  ];
  return bgs[day % bgs.length];
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentClassPageController extends ChangeNotifier {
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

  String? get selectedDay => _selectedDay;
  String? get selectedSubject => _selectedSubject;
  String? get selectedGrade => _selectedGrade;
  String? get selectedStatus => _selectedStatus;

  // ── Source data ─────────────────────────────────────────────
  bool isLoading = false;
  List<StudentClassModel> _allClasses = [];
  List<StudentClassModel> get allClasses => _allClasses;

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchClasses() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _allClasses = studentDummyClasses;

    isLoading = false;
    notifyListeners();
  }

  // ── Computed: active filter count ────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedDay != null) count++;
    if (_selectedSubject != null) count++;
    if (_selectedGrade != null) count++;
    if (_selectedStatus != null) count++;
    return count;
  }

  // ── Computed: filtered list ──────────────────────────────────
  List<StudentClassModel> get filteredClasses {
    return _allClasses.where((cls) {
      final matchesSearch = _searchQuery.isEmpty ||
          cls.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cls.subjectName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          cls.tutorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (cls.instituteName ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesDay =
          _selectedDay == null || cls.day.toString() == _selectedDay;

      final matchesSubject =
          _selectedSubject == null || cls.subjectId == _selectedSubject;

      final matchesGrade =
          _selectedGrade == null || cls.grade.toString() == _selectedGrade;

      final matchesStatus = _selectedStatus == null ||
          cls.status.toUpperCase() == _selectedStatus!.toUpperCase();

      return matchesSearch &&
          matchesDay &&
          matchesSubject &&
          matchesGrade &&
          matchesStatus;
    }).toList();
  }

  // ── Computed: total pages ────────────────────────────────────
  int get totalPages =>
      (filteredClasses.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Computed: current page items ─────────────────────────────
  List<StudentClassModel> get currentPageItems {
    if (filteredClasses.isEmpty) return [];
    final start = _currentPage * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filteredClasses.length);
    return filteredClasses.sublist(start, end);
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
    String? day,
    String? subject,
    String? grade,
    String? status,
  }) {
    _selectedDay = day;
    _selectedSubject = subject;
    _selectedGrade = grade;
    _selectedStatus = status;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDay = null;
    _selectedSubject = null;
    _selectedGrade = null;
    _selectedStatus = null;
    _currentPage = 0;
    notifyListeners();
  }
}
