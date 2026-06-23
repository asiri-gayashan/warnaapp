import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

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
  final String? location;
  final String? description;
  final double amount;
  final String status;
  final String tutorId;
  final String tutorName;
  final String tutorSubject;
  final String? instituteId;
  final String? instituteName;
  final int attendancePercentage;
  final String paymentStatus;
  final int studentCount;

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
    this.location,
    this.description,
    required this.amount,
    required this.status,
    required this.tutorId,
    required this.tutorName,
    required this.tutorSubject,
    this.instituteId,
    this.instituteName,
    required this.attendancePercentage,
    required this.paymentStatus,
    required this.studentCount,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> j) {
    final subjectName = j['subject_name']?.toString() ?? '';
    final startTime = j['start_time']?.toString() ?? '';
    final endTime = j['end_time']?.toString() ?? '';
    return StudentClassModel(
      id: j['id']?.toString() ?? '',
      name: j['name']?.toString() ?? '',
      subjectId: j['subject_id']?.toString() ?? subjectName,
      subjectName: subjectName,
      grade: int.tryParse(j['grade']?.toString() ?? '') ?? 0,
      day: int.tryParse(j['day_num']?.toString() ?? '') ?? 0,
      startTime: startTime,
      endTime: endTime,
      duration: _computeDuration(startTime, endTime),
      location: j['location']?.toString(),
      description: j['description']?.toString(),
      amount: (j['amount'] is num) ? (j['amount'] as num).toDouble() : 0.0,
      status: j['status']?.toString() ?? '',
      tutorId: j['tutor_id']?.toString() ?? '',
      tutorName: j['tutor_name']?.toString() ?? '',
      tutorSubject: subjectName,
      instituteId: j['institute_id']?.toString(),
      instituteName: j['institute_name']?.toString(),
      attendancePercentage: 0,
      paymentStatus: j['is_paid_this_month'] == true
          ? 'PAID'
          : (j['has_pending'] == true ? 'PENDING' : ''),
      studentCount: (j['student_count'] as num?)?.toInt() ?? 0,
    );
  }
}

// ============================================================
// HELPERS
// ============================================================

int _parseAmPm(String time) {
  try {
    final parts = time.trim().split(' ');
    if (parts.length < 2) return 0;
    final timeParts = parts[0].split(':');
    if (timeParts.length < 2) return 0;
    int hours = int.tryParse(timeParts[0]) ?? 0;
    final minutes = int.tryParse(timeParts[1]) ?? 0;
    final isPm = parts[1].toUpperCase() == 'PM';
    if (isPm && hours != 12) hours += 12;
    if (!isPm && hours == 12) hours = 0;
    return hours * 60 + minutes;
  } catch (_) {
    return 0;
  }
}

String _computeDuration(String startTime, String endTime) {
  final s = _parseAmPm(startTime);
  final e = _parseAmPm(endTime);
  if (s == 0 && e == 0) return '';
  final diffMin = e - s;
  if (diffMin <= 0) return '';
  final h = diffMin ~/ 60;
  final m = diffMin % 60;
  if (h > 0 && m > 0) return '${h}h ${m}m';
  if (h > 0) return '${h}h';
  return '${m}m';
}

// ============================================================
// DUMMY DATA (kept for other pages)
// ============================================================

final List<StudentClassModel> studentDummyClasses = [
  const StudentClassModel(
    id: 'c1',
    name: 'Combined Mathematics',
    subjectId: '1',
    subjectName: 'Combined Mathematics',
    grade: 12,
    day: 1,
    startTime: '2:00 PM',
    endTime: '4:00 PM',
    duration: '2h',
    location: 'Bright Future Institute',
    description: 'Comprehensive coverage of the Combined Mathematics syllabus.',
    amount: 4500,
    status: 'ACTIVE',
    tutorId: 't1',
    tutorName: 'Nuwan Perera',
    tutorSubject: 'Mathematics',
    instituteId: 'i1',
    instituteName: 'Bright Future Institute',
    attendancePercentage: 92,
    paymentStatus: 'PAID',
    studentCount: 35,
  ),
];

// ============================================================
// OPTIONS
// ============================================================

const List<String> studentClassStatusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
  'APPROVED',
  'REJECTED',
];

// Class type options
const List<Map<String, String>> studentClassTypeOptions = [
  {'id': 'institute', 'label': 'At Institute'},
  {'id': 'tutor', 'label': 'By Tutor'},
];

// ============================================================
// OPTION HELPERS
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
  final _dio = DioClient.instance;

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
  String? _selectedType;   // 'institute' | 'tutor' | null
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  double? _minFee;
  double? _maxFee;

  String? get selectedDay => _selectedDay;
  String? get selectedSubject => _selectedSubject;
  String? get selectedGrade => _selectedGrade;
  String? get selectedStatus => _selectedStatus;
  String? get selectedType => _selectedType;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  double? get minFee => _minFee;
  double? get maxFee => _maxFee;

  // ── Source data ─────────────────────────────────────────────
  bool isLoading = false;
  List<StudentClassModel> _allClasses = [];
  List<StudentClassModel> get allClasses => _allClasses;

  // ── Fetch ────────────────────────────────────────────────────
  Future<void> fetchClasses() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final userId = user?['id'];
      final response = await _dio.get('/student-dashboard/classes/$userId');
      final List<dynamic> raw = (response.data is List)
          ? List<dynamic>.from(response.data as List)
          : List<dynamic>.from((response.data['data'] as List?) ?? []);
      _allClasses = raw
          .map((e) => StudentClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching student classes: $e');
      _allClasses = [];
    }
    isLoading = false;
    notifyListeners();
  }

  // ── Active filter count ──────────────────────────────────────
  int get activeFilterCount {
    int count = 0;
    if (_selectedDay != null) count++;
    if (_selectedSubject != null) count++;
    if (_selectedGrade != null) count++;
    if (_selectedStatus != null) count++;
    if (_selectedType != null) count++;
    if (_startTime != null || _endTime != null) count++;
    if (_minFee != null || _maxFee != null) count++;
    return count;
  }

  // ── Filtered list ────────────────────────────────────────────
  List<StudentClassModel> get filteredClasses {
    return _allClasses.where((cls) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          cls.name.toLowerCase().contains(q) ||
          cls.subjectName.toLowerCase().contains(q) ||
          cls.tutorName.toLowerCase().contains(q) ||
          (cls.instituteName ?? '').toLowerCase().contains(q);

      final matchesDay =
          _selectedDay == null || cls.day.toString() == _selectedDay;

      final matchesSubject =
          _selectedSubject == null || cls.subjectId == _selectedSubject;

      final matchesGrade =
          _selectedGrade == null || cls.grade.toString() == _selectedGrade;

      final matchesStatus = _selectedStatus == null ||
          cls.status.toUpperCase() == _selectedStatus!.toUpperCase();

      final matchesType = _selectedType == null ||
          (_selectedType == 'institute' && cls.instituteId != null) ||
          (_selectedType == 'tutor' && cls.instituteId == null);

      bool matchesTime = true;
      if (_startTime != null || _endTime != null) {
        final clsStart = _parseAmPm(cls.startTime);
        final filterStart = _startTime != null
            ? _startTime!.hour * 60 + _startTime!.minute
            : 0;
        final filterEnd = _endTime != null
            ? _endTime!.hour * 60 + _endTime!.minute
            : 24 * 60;
        matchesTime = clsStart >= filterStart && clsStart <= filterEnd;
      }

      final matchesFee =
          (_minFee == null || cls.amount >= _minFee!) &&
          (_maxFee == null || cls.amount <= _maxFee!);

      return matchesSearch &&
          matchesDay &&
          matchesSubject &&
          matchesGrade &&
          matchesStatus &&
          matchesType &&
          matchesTime &&
          matchesFee;
    }).toList();
  }

  // ── Total pages ──────────────────────────────────────────────
  int get totalPages =>
      (filteredClasses.length / itemsPerPage).ceil().clamp(1, 999);

  // ── Current page items ───────────────────────────────────────
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
    String? type,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    double? minFee,
    double? maxFee,
  }) {
    _selectedDay = day;
    _selectedSubject = subject;
    _selectedGrade = grade;
    _selectedStatus = status;
    _selectedType = type;
    _startTime = startTime;
    _endTime = endTime;
    _minFee = minFee;
    _maxFee = maxFee;
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _selectedDay = null;
    _selectedSubject = null;
    _selectedGrade = null;
    _selectedStatus = null;
    _selectedType = null;
    _startTime = null;
    _endTime = null;
    _minFee = null;
    _maxFee = null;
    _currentPage = 0;
    notifyListeners();
  }
}
