import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import '../../../../shared/widgets/new/class_selection_card.dart';
import '../../../../shared/widgets/new/enrollment_stats_row.dart';
import '../../../../shared/widgets/new/enrollment_search_bar.dart';
import '../../../../shared/widgets/new/enrollment_list_header.dart';
import '../../../../shared/widgets/new/enrollment_student_table.dart';
import '../../../../shared/widgets/new/numbered_pagination.dart';
import '../../../../shared/widgets/new/save_enrollments_button.dart';

class EnrollStudentPage extends StatefulWidget {
  const EnrollStudentPage({Key? key}) : super(key: key);

  @override
  State<EnrollStudentPage> createState() => _EnrollStudentPageState();
}

class _EnrollStudentPageState extends State<EnrollStudentPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClass;
  String _selectedFilter = 'All'; // All, Enrolled, Unenrolled
  bool _selectAll = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Sample classes
  final List<String> _classes = [
    'Advanced Mathematics - Grade 10',
    'Physics Fundamentals - Grade 11',
    'Chemistry Lab - Grade 10',
    'English Literature - Grade 9',
    'Computer Science - Grade 11',
  ];

  // Sample students with enrollment status
  final List<Map<String, dynamic>> _allStudents = [
    {
      'rollNo': 'S001',
      'name': 'Emma Watson',
      'enrolled': true,
      'enrolledDate': '2024-01-15',
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S002',
      'name': 'James Smith',
      'enrolled': false,
      'enrolledDate': null,
      'grade': 'Grade 11',
    },
    {
      'rollNo': 'S003',
      'name': 'Michael Brown',
      'enrolled': true,
      'enrolledDate': '2024-01-20',
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S004',
      'name': 'Sarah Johnson',
      'enrolled': true,
      'enrolledDate': '2024-01-10',
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S005',
      'name': 'David Wilson',
      'enrolled': false,
      'enrolledDate': null,
      'grade': 'Grade 11',
    },
    {
      'rollNo': 'S006',
      'name': 'Emily Davis',
      'enrolled': true,
      'enrolledDate': '2024-02-01',
      'grade': 'Grade 9',
    },
    {
      'rollNo': 'S007',
      'name': 'Daniel Martinez',
      'enrolled': true,
      'enrolledDate': '2024-01-18',
      'grade': 'Grade 11',
    },
    {
      'rollNo': 'S008',
      'name': 'Lisa Anderson',
      'enrolled': false,
      'enrolledDate': null,
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S009',
      'name': 'Robert Taylor',
      'enrolled': true,
      'enrolledDate': '2024-01-25',
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S010',
      'name': 'Jennifer Thomas',
      'enrolled': true,
      'enrolledDate': '2024-01-12',
      'grade': 'Grade 9',
    },
    {
      'rollNo': 'S011',
      'name': 'William Jackson',
      'enrolled': false,
      'enrolledDate': null,
      'grade': 'Grade 11',
    },
    {
      'rollNo': 'S012',
      'name': 'Mary White',
      'enrolled': true,
      'enrolledDate': '2024-02-05',
      'grade': 'Grade 9',
    },
    {
      'rollNo': 'S013',
      'name': 'Joseph Harris',
      'enrolled': true,
      'enrolledDate': '2024-01-22',
      'grade': 'Grade 10',
    },
    {
      'rollNo': 'S014',
      'name': 'Patricia Martin',
      'enrolled': false,
      'enrolledDate': null,
      'grade': 'Grade 11',
    },
    {
      'rollNo': 'S015',
      'name': 'Charles Thompson',
      'enrolled': true,
      'enrolledDate': '2024-01-28',
      'grade': 'Grade 10',
    },
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((student) {
      // Search filter
      final searchMatch =
          _searchController.text.isEmpty ||
          student['name'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student['rollNo'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student['grade'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      // Enrollment status filter
      bool statusMatch = true;
      if (_selectedFilter == 'Enrolled') {
        statusMatch = student['enrolled'] == true;
      } else if (_selectedFilter == 'Unenrolled') {
        statusMatch = student['enrolled'] == false;
      }

      // Class filter (simplified - in real app would match class ID)
      bool classMatch =
          _selectedClass == null ||
          _selectedClass == 'All Classes' ||
          student['grade'] == _selectedClass?.split(' - ')[1];

      return searchMatch && statusMatch && classMatch;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedStudents {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredStudents.length) return [];
    return _filteredStudents.sublist(
      startIndex,
      endIndex > _filteredStudents.length ? _filteredStudents.length : endIndex,
    );
  }

  int get _totalPages => (_filteredStudents.length / _itemsPerPage).ceil();
  int get _enrolledCount =>
      _filteredStudents.where((s) => s['enrolled'] == true).length;
  int get _unenrolledCount =>
      _filteredStudents.where((s) => s['enrolled'] == false).length;
  int get _totalStudents => _filteredStudents.length;

  void _toggleAllEnrollment() {
    setState(() {
      _selectAll = !_selectAll;
      for (var student in _paginatedStudents) {
        student['enrolled'] = _selectAll;
        if (_selectAll) {
          student['enrolledDate'] = DateTime.now().toString().split(' ')[0];
        } else {
          student['enrolledDate'] = null;
        }
      }
    });
  }

  void _toggleStudentEnrollment(int index) {
    setState(() {
      _paginatedStudents[index]['enrolled'] =
          !_paginatedStudents[index]['enrolled'];

      // Update enrollment date
      if (_paginatedStudents[index]['enrolled']) {
        _paginatedStudents[index]['enrolledDate'] = DateTime.now()
            .toString()
            .split(' ')[0];
      } else {
        _paginatedStudents[index]['enrolledDate'] = null;
      }

      // Check if all are selected to update selectAll
      _selectAll = _paginatedStudents.every((s) => s['enrolled'] == true);
    });
  }

  void _saveEnrollments() {
    final newlyEnrolled = _paginatedStudents
        .where((s) => s['enrolled'] == true)
        .length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Enrollments saved! $newlyEnrolled students enrolled in this class',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Enroll Students Institute',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Class Selection
            ClassSelectionCard(
              selectedClass: _selectedClass,
              classes: _classes,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue;
                  _currentPage = 1;
                  _selectAll = false;
                });
              },
            ),

            const SizedBox(height: 24),

            // Stats Cards
            EnrollmentStatsRow(
              totalStudents: _totalStudents,
              enrolledCount: _enrolledCount,
            ),

            const SizedBox(height: 20),

            // Search Bar and Filters
            EnrollmentSearchBar(
              searchController: _searchController,
              onChanged: (value) {
                setState(() {
                  _currentPage = 1;
                  _selectAll = false;
                });
              },
              onClear: () {
                setState(() {
                  _searchController.clear();
                  _currentPage = 1;
                });
              },
            ),

            const SizedBox(height: 20),

            // Student List Header with Select All
            EnrollmentListHeader(
              hasStudents: _paginatedStudents.isNotEmpty,
              selectAll: _selectAll,
              onToggleAll: _toggleAllEnrollment,
            ),

            const SizedBox(height: 12),

            // Student Table
            EnrollmentStudentTable(
              paginatedStudents: _paginatedStudents,
              onToggleStudent: _toggleStudentEnrollment,
            ),

            const SizedBox(height: 20),

            // Pagination
            if (_filteredStudents.isNotEmpty && _totalPages > 1)
              NumberedPagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ),

            const SizedBox(height: 20),

            // Summary and Save Button
            SaveEnrollmentsButton(
              isEnabled:
                  _selectedClass != null && _selectedClass != 'All Classes',
              onSave: _saveEnrollments,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
