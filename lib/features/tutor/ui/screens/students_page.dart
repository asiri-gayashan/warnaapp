import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'student_detail_page.dart'; // You'll need to create this

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClass;
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  // Sample classes for filter
  final List<String> _classes = [
    'All Classes',
    'Advanced Mathematics - Grade 10',
    'Physics Fundamentals - Grade 11',
    'Chemistry Lab - Grade 10',
    'English Literature - Grade 9',
    'Computer Science - Grade 11',
  ];

  // Sample students data
  final List<Map<String, dynamic>> _allStudents = [
    {
      'id': 'S001',
      'name': 'Emma Watson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 92,
      'sessions': 1,
      'email': 'emma.w@example.com',
      'phone': '+94 77 123 4567',
    },
    {
      'id': 'S002',
      'name': 'James Smith',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 78,
      'sessions': 1,
      'email': 'james.s@example.com',
      'phone': '+94 77 234 5678',
    },
    {
      'id': 'S003',
      'name': 'Michael Brown',
      'subject': 'Chemistry',
      'grade': 'Grade 10',
      'attendance': 88,
      'sessions': 2,
      'email': 'michael.b@example.com',
      'phone': '+94 77 345 6789',
    },
    {
      'id': 'S004',
      'name': 'Sarah Johnson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 95,
      'sessions': 2,
      'email': 'sarah.j@example.com',
      'phone': '+94 77 456 7890',
    },
    {
      'id': 'S005',
      'name': 'David Wilson',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 82,
      'sessions': 2,
      'email': 'david.w@example.com',
      'phone': '+94 77 567 8901',
    },
    {
      'id': 'S006',
      'name': 'Emily Davis',
      'subject': 'English',
      'grade': 'Grade 9',
      'attendance': 96,
      'sessions': 2,
      'email': 'emily.d@example.com',
      'phone': '+94 77 678 9012',
    },
    {
      'id': 'S007',
      'name': 'Daniel Martinez',
      'subject': 'Computer Science',
      'grade': 'Grade 11',
      'attendance': 89,
      'sessions': 2,
      'email': 'daniel.m@example.com',
      'phone': '+94 77 789 0123',
    },
    {
      'id': 'S008',
      'name': 'Lisa Anderson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 91,
      'sessions': 2,
      'email': 'lisa.a@example.com',
      'phone': '+94 77 890 1234',
    },
    {
      'id': 'S009',
      'name': 'Robert Taylor',
      'subject': 'Chemistry',
      'grade': 'Grade 10',
      'attendance': 84,
      'sessions': 2,
      'email': 'robert.t@example.com',
      'phone': '+94 77 901 2345',
    },
    {
      'id': 'S010',
      'name': 'Jennifer Thomas',
      'subject': 'Biology',
      'grade': 'Grade 9',
      'attendance': 93,
      'sessions': 2,
      'email': 'jennifer.t@example.com',
      'phone': '+94 77 012 3456',
    },
    {
      'id': 'S011',
      'name': 'William Jackson',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 79,
      'sessions': 3,
      'email': 'william.j@example.com',
      'phone': '+94 77 123 4567',
    },
    {
      'id': 'S012',
      'name': 'Mary White',
      'subject': 'English',
      'grade': 'Grade 9',
      'attendance': 97,
      'sessions': 2,
      'email': 'mary.w@example.com',
      'phone': '+94 77 234 5678',
    },
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((student) {
      // Class filter
      final classMatch = _selectedClass == null ||
          _selectedClass == 'All Classes' ||
          student['subject'] == _selectedClass?.split(' - ')[0];

      // Search filter
      final searchMatch = _searchController.text.isEmpty ||
          student['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['id'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['subject'].toLowerCase().contains(_searchController.text.toLowerCase());

      return classMatch && searchMatch;
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

  void _onStudentTap(Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Students',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Class Filter Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Class'),
                      value: _selectedClass,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      items: _classes.map((className) {
                        return DropdownMenuItem(
                          value: className,
                          child: Text(
                            className,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedClass = value;
                          _currentPage = 1;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, ID, or subject...',
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
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _currentPage = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredStudents.length} students found',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                if (_filteredStudents.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Page $_currentPage of $_totalPages',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: _filteredStudents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _paginatedStudents.length,
              itemBuilder: (context, index) {
                final student = _paginatedStudents[index];
                return _buildStudentCard(student, index);
              },
            ),
          ),

          // Pagination
          if (_filteredStudents.isNotEmpty && _totalPages > 1)
            _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, int index) {
    // Determine attendance color
    Color attendanceColor= AppColors.success;


    return GestureDetector(
      onTap: () => _onStudentTap(student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with student initial
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                student['name'][0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Student Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${student['subject']} • ${student['grade']}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Attendance badge
                      // Attendance badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: attendanceColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call,
                              size: 12,
                              color: attendanceColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '0768645011',
                              style: TextStyle(
                                color: attendanceColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Sessions badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_call,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '2 Classes',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Message Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  // TODO: Navigate to chat/messaging
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Messaging ${student['name']}'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.remove_red_eye_outlined),
                color: AppColors.primary,
                iconSize: 20,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline,
              size: 50,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty || _selectedClass != null
                ? 'Try adjusting your search or filters'
                : 'No students assigned yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (_searchController.text.isNotEmpty || _selectedClass != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedClass = null;
                  _currentPage = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
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
            iconSize: 24,
          ),

          const SizedBox(width: 8),

          // Page numbers
          ...List.generate(
            _totalPages > 5 ? 5 : _totalPages,
                (index) {
              int pageNum;
              if (_totalPages <= 5) {
                pageNum = index + 1;
              } else if (_currentPage <= 3) {
                pageNum = index + 1;
              } else if (_currentPage >= _totalPages - 2) {
                pageNum = _totalPages - 4 + index;
              } else {
                pageNum = _currentPage - 2 + index;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = pageNum;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 36,
                  height: 36,
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // Next button
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
            iconSize: 24,
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