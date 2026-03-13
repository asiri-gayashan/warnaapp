import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

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
      return student['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['rollNo'].toLowerCase().contains(_searchController.text.toLowerCase());
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
  int get _presentCount => _filteredStudents.where((s) => s['attendance'] == true).length;
  int get _absentCount => _filteredStudents.where((s) => s['attendance'] == false).length;

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
      _paginatedStudents[index]['attendance'] = !_paginatedStudents[index]['attendance'];
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
    final presentStudents = _allStudents.where((s) => s['attendance'] == true).length;
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
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Filters
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Class & Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Class Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text(
                          'Select Class',
                          style: TextStyle(color: Colors.white70),
                        ),
                        value: _selectedClass,
                        dropdownColor: AppColors.primary,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _classes.map((String className) {
                          return DropdownMenuItem<String>(
                            value: className,
                            child: Text(
                              className,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedClass = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Date Selector
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    '${_filteredStudents.length}',
                    Icons.people_alt,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Present',
                    '$_presentCount',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Absent',
                    '$_absentCount',
                    Icons.cancel,
                    Colors.red,
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
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                            color: _selectAll ? AppColors.primary : AppColors.textDisabled,
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
              _buildPagination(),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedClass == null
                    ? null
                    : _saveAttendance,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
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
                  Expanded(flex: 2, child: Text('Roll No', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 3, child: Text('Student Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 1, child: Text('Mark', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
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
                  color: isEven ? Colors.white : AppColors.background.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          student['rollNo'],
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
                                color: student['attendance'] ? AppColors.success : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              student['attendance'] ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontSize: 12,
                                color: student['attendance'] ? AppColors.success : Colors.red,
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

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () {
              setState(() {
                _currentPage--;
              });
            }
                : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? AppColors.primary : AppColors.textDisabled,
            iconSize: 20,
          ),
          const SizedBox(width: 4),
          ...List.generate(
            _totalPages > 3 ? 3 : _totalPages,
                (index) {
              int pageNum = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = pageNum;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _currentPage == pageNum
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      pageNum.toString(),
                      style: TextStyle(
                        color: _currentPage == pageNum
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: _currentPage == pageNum
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _currentPage < _totalPages
                ? () {
              setState(() {
                _currentPage++;
              });
            }
                : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < _totalPages ? AppColors.primary : AppColors.textDisabled,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}