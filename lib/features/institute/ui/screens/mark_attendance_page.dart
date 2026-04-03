import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/shared/widgets/new/stat_card.dart';
import 'package:warna_app/shared/widgets/new/selection_header_card.dart';
import 'package:warna_app/shared/widgets/new/custom_pagination.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({Key? key}) : super(key: key);

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClass;
  DateTime _selectedDate = DateTime.now();
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

  // Sample students
  final List<Map<String, dynamic>> _allStudents = [
    {'rollNo': 'S001', 'name': 'Emma Watson', 'attendance': false},
    {'rollNo': 'S002', 'name': 'James Smith', 'attendance': false},
    {'rollNo': 'S003', 'name': 'Michael Brown', 'attendance': false},
    {'rollNo': 'S004', 'name': 'Sarah Johnson', 'attendance': false},
    {'rollNo': 'S005', 'name': 'David Wilson', 'attendance': false},
    {'rollNo': 'S006', 'name': 'Emily Davis', 'attendance': false},
    {'rollNo': 'S007', 'name': 'Daniel Martinez', 'attendance': false},
    {'rollNo': 'S008', 'name': 'Lisa Anderson', 'attendance': false},
    {'rollNo': 'S009', 'name': 'Robert Taylor', 'attendance': false},
    {'rollNo': 'S010', 'name': 'Jennifer Thomas', 'attendance': false},
    {'rollNo': 'S011', 'name': 'William Jackson', 'attendance': false},
    {'rollNo': 'S012', 'name': 'Mary White', 'attendance': false},
    {'rollNo': 'S013', 'name': 'Joseph Harris', 'attendance': false},
    {'rollNo': 'S014', 'name': 'Patricia Martin', 'attendance': false},
    {'rollNo': 'S015', 'name': 'Charles Thompson', 'attendance': false},
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchController.text.isEmpty) {
      return _allStudents;
    }
    return _allStudents.where((student) {
      return student['name'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student['rollNo'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
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
  int get _presentCount =>
      _filteredStudents.where((s) => s['attendance'] == true).length;
  int get _absentCount =>
      _filteredStudents.where((s) => s['attendance'] == false).length;

  void _toggleAllAttendance() {
    setState(() {
      _selectAll = !_selectAll;
      for (var student in _paginatedStudents) {
        student['attendance'] = _selectAll;
      }
    });
  }

  void _toggleStudentAttendance(int index) {
    setState(() {
      _paginatedStudents[index]['attendance'] =
          !_paginatedStudents[index]['attendance'];
      // Check if all are selected to update selectAll
      _selectAll = _paginatedStudents.every((s) => s['attendance'] == true);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved!'),
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
          'Mark Attendance Institute',
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
            // Header Card with Filters
            SelectionHeaderCard(
              title: 'Select Class & Date',
              classHint: 'Select Class',
              classes: _classes,
              selectedClass: _selectedClass,
              onClassChanged: (newValue) =>
                  setState(() => _selectedClass = newValue),
              dateText:
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              dateIcon: Icons.calendar_today,
              onDateTap: () => _selectDate(context),
            ),

            const SizedBox(height: 24),
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total Students',
                    value: '${_filteredStudents.length}',
                    icon: Icons.people_alt,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Present',
                    value: '$_presentCount',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Absent',
                    value: '$_absentCount',
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or roll number...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _currentPage = 1;
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {
                    _currentPage = 1;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Student List Header with Select All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    const Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleAllAttendance,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _selectAll ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _selectAll
                                ? AppColors.primary
                                : AppColors.textDisabled,
                            width: 1.5,
                          ),
                        ),
                        child: _selectAll
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Student Table
            _buildStudentTable(),

            const SizedBox(height: 20),

            // Pagination
            if (_filteredStudents.isNotEmpty && _totalPages > 1)
              CustomPagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
                onPageChanged: (page) => setState(() => _currentPage = page),
              ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedClass == null ? null : _saveAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Save Attendance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(14),
              color: AppColors.primary.withOpacity(0.04),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Roll No',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Student Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Mark',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Body
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paginatedStudents.length,
              itemBuilder: (context, index) {
                final student = _paginatedStudents[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.all(14),
                  color: isEven
                      ? Colors.white
                      : AppColors.background.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          student['rollNo'],
                          style: const TextStyle(  
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          student['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: student['attendance']
                                    ? AppColors.success
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              student['attendance'] ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontSize: 12,
                                color: student['attendance']
                                    ? AppColors.success
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => _toggleStudentAttendance(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: student['attendance']
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: student['attendance']
                                    ? AppColors.success
                                    : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            child: student['attendance']
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.success,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
