import 'package:flutter/material.dart';

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

  // ── Fetch (dummy data) ────────────────────────────────────────
  Future<bool> fetchStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    _allStudents = [
      TutorStudentModel(
        id: 'std-1',
        userId: 'usr-std-1',
        dob: DateTime(now.year - 17, 3, 12),
        age: 17,
        school: 'Royal College',
        grade: 12,
        createdAt: now.subtract(const Duration(days: 200)),
        fullName: 'Nimal Perera',
        email: 'nimal.perera@example.com',
        phone: '+94 71 234 5678',
        addressLine1: 'No. 12, Galle Road, Colombo 03',
        addressLine2: '',
        description: 'Aiming for the medical stream after A/Ls.',
        districtId: '1',
        districtName: 'Colombo',
        status: 'ACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-2',
        userId: 'usr-std-2',
        dob: DateTime(now.year - 17, 7, 22),
        age: 17,
        school: 'Visakha Vidyalaya',
        grade: 12,
        createdAt: now.subtract(const Duration(days: 180)),
        fullName: 'Kavindi Silva',
        email: 'kavindi.silva@example.com',
        phone: '+94 77 345 6789',
        addressLine1: 'No. 45, Ward Place, Colombo 07',
        addressLine2: '',
        description: 'Strong in mathematics and physics.',
        districtId: '1',
        districtName: 'Colombo',
        status: 'ACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-3',
        userId: 'usr-std-3',
        dob: DateTime(now.year - 16, 1, 5),
        age: 16,
        school: 'Ananda College',
        grade: 11,
        createdAt: now.subtract(const Duration(days: 150)),
        fullName: 'Tharindu Fernando',
        email: 'tharindu.fernando@example.com',
        phone: '+94 76 456 7890',
        addressLine1: 'No. 8, Maradana Road, Colombo 10',
        addressLine2: '',
        description: 'Enjoys problem solving and group study sessions.',
        districtId: '1',
        districtName: 'Colombo',
        status: 'ACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-4',
        userId: 'usr-std-4',
        dob: DateTime(now.year - 15, 11, 30),
        age: 15,
        school: 'Nalanda College',
        grade: 10,
        createdAt: now.subtract(const Duration(days: 120)),
        fullName: 'Sahan Jayasuriya',
        email: 'sahan.jayasuriya@example.com',
        phone: '+94 70 987 6543',
        addressLine1: 'No. 21, Kandy Road, Colombo 10',
        addressLine2: '',
        description: '',
        districtId: '1',
        districtName: 'Colombo',
        status: 'ACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-5',
        userId: 'usr-std-5',
        dob: DateTime(now.year - 14, 5, 18),
        age: 14,
        school: 'Devi Balika Vidyalaya',
        grade: 9,
        createdAt: now.subtract(const Duration(days: 90)),
        fullName: 'Dilani Wickramasinghe',
        email: 'dilani.w@example.com',
        phone: '+94 71 555 1234',
        addressLine1: 'No. 67, Negombo Road, Wattala',
        addressLine2: '',
        description: 'Recently moved from another tuition class.',
        districtId: '2',
        districtName: 'Gampaha',
        status: 'INACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-6',
        userId: 'usr-std-6',
        dob: DateTime(now.year - 18, 9, 2),
        age: 18,
        school: "St. Joseph's College",
        grade: 13,
        createdAt: now.subtract(const Duration(days: 320)),
        fullName: 'Ruwan Bandara',
        email: 'ruwan.bandara@example.com',
        phone: '+94 77 888 2233',
        addressLine1: 'No. 5, Hill Street, Colombo 04',
        addressLine2: '',
        description: 'Repeating A/Ls, focused on combined mathematics.',
        districtId: '1',
        districtName: 'Colombo',
        status: 'ACTIVE',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-7',
        userId: 'usr-std-7',
        dob: DateTime(now.year - 13, 2, 14),
        age: 13,
        school: 'Musaeus College',
        grade: 8,
        createdAt: now.subtract(const Duration(days: 30)),
        fullName: 'Amaya Perera',
        email: 'amaya.perera@example.com',
        phone: '+94 76 222 9988',
        addressLine1: 'No. 33, Bauddhaloka Mawatha, Colombo 04',
        addressLine2: '',
        description: 'Newly registered, awaiting approval.',
        districtId: '1',
        districtName: 'Colombo',
        status: 'PENDING',
        role: 'STUDENT',
      ),
      TutorStudentModel(
        id: 'std-8',
        userId: 'usr-std-8',
        dob: DateTime(now.year - 17, 12, 9),
        age: 17,
        school: 'Royal College',
        grade: 12,
        createdAt: now.subtract(const Duration(days: 60)),
        fullName: 'Chamara Silva',
        email: 'chamara.silva@example.com',
        phone: '+94 70 444 7766',
        addressLine1: 'No. 14, Negombo Road, Ja-Ela',
        addressLine2: '',
        description: '',
        districtId: '2',
        districtName: 'Gampaha',
        status: 'APPROVED',
        role: 'STUDENT',
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
