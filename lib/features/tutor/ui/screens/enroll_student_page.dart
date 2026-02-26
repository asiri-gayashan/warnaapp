import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

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
    {'rollNo': 'S001', 'name': 'Emma Watson', 'enrolled': true, 'enrolledDate': '2024-01-15', 'grade': 'Grade 10'},
    {'rollNo': 'S002', 'name': 'James Smith', 'enrolled': false, 'enrolledDate': null, 'grade': 'Grade 11'},
    {'rollNo': 'S003', 'name': 'Michael Brown', 'enrolled': true, 'enrolledDate': '2024-01-20', 'grade': 'Grade 10'},
    {'rollNo': 'S004', 'name': 'Sarah Johnson', 'enrolled': true, 'enrolledDate': '2024-01-10', 'grade': 'Grade 10'},
    {'rollNo': 'S005', 'name': 'David Wilson', 'enrolled': false, 'enrolledDate': null, 'grade': 'Grade 11'},
    {'rollNo': 'S006', 'name': 'Emily Davis', 'enrolled': true, 'enrolledDate': '2024-02-01', 'grade': 'Grade 9'},
    {'rollNo': 'S007', 'name': 'Daniel Martinez', 'enrolled': true, 'enrolledDate': '2024-01-18', 'grade': 'Grade 11'},
    {'rollNo': 'S008', 'name': 'Lisa Anderson', 'enrolled': false, 'enrolledDate': null, 'grade': 'Grade 10'},
    {'rollNo': 'S009', 'name': 'Robert Taylor', 'enrolled': true, 'enrolledDate': '2024-01-25', 'grade': 'Grade 10'},
    {'rollNo': 'S010', 'name': 'Jennifer Thomas', 'enrolled': true, 'enrolledDate': '2024-01-12', 'grade': 'Grade 9'},
    {'rollNo': 'S011', 'name': 'William Jackson', 'enrolled': false, 'enrolledDate': null, 'grade': 'Grade 11'},
    {'rollNo': 'S012', 'name': 'Mary White', 'enrolled': true, 'enrolledDate': '2024-02-05', 'grade': 'Grade 9'},
    {'rollNo': 'S013', 'name': 'Joseph Harris', 'enrolled': true, 'enrolledDate': '2024-01-22', 'grade': 'Grade 10'},
    {'rollNo': 'S014', 'name': 'Patricia Martin', 'enrolled': false, 'enrolledDate': null, 'grade': 'Grade 11'},
    {'rollNo': 'S015', 'name': 'Charles Thompson', 'enrolled': true, 'enrolledDate': '2024-01-28', 'grade': 'Grade 10'},
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((student) {
      // Search filter
      final searchMatch = _searchController.text.isEmpty ||
          student['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['rollNo'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['grade'].toLowerCase().contains(_searchController.text.toLowerCase());

      // Enrollment status filter
      bool statusMatch = true;
      if (_selectedFilter == 'Enrolled') {
        statusMatch = student['enrolled'] == true;
      } else if (_selectedFilter == 'Unenrolled') {
        statusMatch = student['enrolled'] == false;
      }

      // Class filter (simplified - in real app would match class ID)
      bool classMatch = _selectedClass == null ||
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
  int get _enrolledCount => _filteredStudents.where((s) => s['enrolled'] == true).length;
  int get _unenrolledCount => _filteredStudents.where((s) => s['enrolled'] == false).length;
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
      _paginatedStudents[index]['enrolled'] = !_paginatedStudents[index]['enrolled'];

      // Update enrollment date
      if (_paginatedStudents[index]['enrolled']) {
        _paginatedStudents[index]['enrolledDate'] = DateTime.now().toString().split(' ')[0];
      } else {
        _paginatedStudents[index]['enrolledDate'] = null;
      }

      // Check if all are selected to update selectAll
      _selectAll = _paginatedStudents.every((s) => s['enrolled'] == true);
    });
  }

  void _saveEnrollments() {
    final newlyEnrolled = _paginatedStudents.where((s) => s['enrolled'] == true).length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enrollments saved! $newlyEnrolled students enrolled in this class'),
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
          'Enroll Students',
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
            // Header Card with Class Selection
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
                    'Select Class',
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
                          'Choose a class',
                          style: TextStyle(color: Colors.white70),
                        ),
                        value: _selectedClass,
                        dropdownColor: AppColors.primary,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: [
                          const DropdownMenuItem(
                            value: 'All Classes',
                            child: Text('All Classes', style: TextStyle(color: Colors.white)),
                          ),
                          ..._classes.map((String className) {
                            return DropdownMenuItem<String>(
                              value: className,
                              child: Text(
                                className,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedClass = newValue;
                            _currentPage = 1;
                            _selectAll = false;
                          });
                        },
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
                    '$_totalStudents',
                    Icons.people_alt,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Enrolled',
                    '$_enrolledCount',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            // Search Bar and Filters
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
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, roll number, or grade...',
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
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentPage = 1;
                        _selectAll = false;
                      });
                    },
                  ),

                  // Filter Chips

                ],
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
                if (_paginatedStudents.isNotEmpty)
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
                        onTap: _toggleAllEnrollment,
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

            // Summary and Save Button
            Container(
              padding: const EdgeInsets.all(16),
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedClass == null || _selectedClass == 'All Classes'
                          ? null
                          : _saveEnrollments,
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
                        'Save Enrollments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
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
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _currentPage = 1;
          _selectAll = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentTable() {
    if (_paginatedStudents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
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
            Icon(
              Icons.people_outline,
              size: 50,
              color: AppColors.textDisabled.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No students found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

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
                  Expanded(flex: 2, child: Text('Grade', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 1, child: Text('Enroll', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
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
                        child: Text(
                          student['grade'],
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => _toggleStudentEnrollment(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: student['enrolled']
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: student['enrolled']
                                    ? AppColors.success
                                    : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            child: student['enrolled']
                                ? const Icon(
                              Icons.check,
                              color: AppColors.success,
                              size: 16,
                            )
                                : const Icon(
                              Icons.add,
                              color: AppColors.textDisabled,
                              size: 16,
                            ),
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