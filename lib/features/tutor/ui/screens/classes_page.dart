import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/class_card2.dart';
import '../../models/class_model.dart';
import 'class_detail_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDay = 'All';
  String _selectedSubject = 'All';
  String _selectedGrade = 'All';
  int _currentPage = 1;
  final int _itemsPerPage = 4;

  final List<String> _days = ['All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _subjects = ['All', 'Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'History', 'Computer Science'];
  final List<String> _grades = ['All', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'];

  // Sample class data
  final List<ClassModel> _allClasses = [
    ClassModel(
      id: '1',
      name: 'Advanced Mathematics',
      subject: 'Mathematics',
      grade: 'Grade 10',
      day: 'Monday',
      time: '10:30 AM',
      duration: '60 min',
      totalStudents: 24,
      location: "Kurunegala",
      description: 'Advanced mathematics course covering algebra, calculus, and trigonometry with practical applications.',
      status: true,
    ),
    ClassModel(
      id: '2',
      name: 'Physics Fundamentals',
      subject: 'Physics',
      grade: 'Grade 11',
      day: 'Tuesday',
      time: '2:00 PM',
      duration: '90 min',
      totalStudents: 18,
      location: "Kurunegala",
      description: 'Comprehensive physics course covering mechanics, thermodynamics, and wave phenomena.',

      status: true,
    ),
    ClassModel(
      id: '3',
      name: 'Chemistry Lab',
      subject: 'Chemistry',
      grade: 'Grade 10',
      day: 'Wednesday',
      time: '9:00 AM',
      duration: '120 min',
      totalStudents: 16,
      location: "Kurunegala",
      description: 'Hands-on chemistry laboratory sessions covering experiments, safety, and analysis.',

      status: true,
    ),
    ClassModel(
      id: '4',
      name: 'English Literature',
      subject: 'English',
      grade: 'Grade 9',
      day: 'Thursday',
      time: '11:30 AM',
      duration: '60 min',
      totalStudents: 22,
      location: "Kurunegala",
      description: 'Explore classic and modern literature with focus on analysis, writing, and discussion.',

      status: true,
    ),
    ClassModel(
      id: '5',
      name: 'Computer Science',
      subject: 'Computer Science',
      grade: 'Grade 11',
      day: 'Friday',
      time: '3:30 PM',
      duration: '90 min',
      totalStudents: 20,
      location: "Kurunegala",
      description: 'Introduction to programming, algorithms, and data structures using Python.',

      status: true,
    ),
    ClassModel(
      id: '6',
      name: 'Biology Essentials',
      subject: 'Biology',
      grade: 'Grade 10',
      day: 'Monday',
      time: '1:00 PM',
      duration: '60 min',
      totalStudents: 19,
      location: "Kurunegala",
      description: 'Fundamental concepts of biology including cell structure, genetics, and ecology.',
      status: true,
    ),
  ];

  List<ClassModel> get _filteredClasses {
    return _allClasses.where((classItem) {
      // Search filter
      final searchMatch = _searchController.text.isEmpty ||
          classItem.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          classItem.location.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          classItem.subject.toLowerCase().contains(_searchController.text.toLowerCase());

      // Day filter
      final dayMatch = _selectedDay == 'All' || classItem.day == _selectedDay;

      // Subject filter
      final subjectMatch = _selectedSubject == 'All' || classItem.subject == _selectedSubject;

      // Grade filter
      final gradeMatch = _selectedGrade == 'All' || classItem.grade == _selectedGrade;

      return searchMatch && dayMatch && subjectMatch && gradeMatch;
    }).toList();
  }

  List<ClassModel> get _paginatedClasses {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredClasses.length) return [];
    return _filteredClasses.sublist(
      startIndex,
      endIndex > _filteredClasses.length ? _filteredClasses.length : endIndex,
    );
  }

  int get _totalPages => (_filteredClasses.length / _itemsPerPage).ceil();

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedDay = 'All';
      _selectedSubject = 'All';
      _selectedGrade = 'All';
      _currentPage = 1;
    });
  }

  Widget _buildPageButton(int pageNum) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = pageNum;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _currentPage == pageNum ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            pageNum.toString(),
            style: TextStyle(
              color: _currentPage == pageNum ? Colors.white : AppColors.textPrimary,
              fontWeight: _currentPage == pageNum ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Classes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search classes by name, tutor, or subject...',
                      hintStyle: TextStyle(color: AppColors.textDisabled),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
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

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'Day: $_selectedDay',
                    icon: Icons.calendar_today,
                    onTap: () => _showFilterModal('day'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Subject: $_selectedSubject',
                    icon: Icons.menu_book,
                    onTap: () => _showFilterModal('subject'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Grade: $_selectedGrade',
                    icon: Icons.school,
                    onTap: () => _showFilterModal('grade'),
                  ),
                  if (_selectedDay != 'All' || _selectedSubject != 'All' || _selectedGrade != 'All')
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextButton(
                        onPressed: _resetFilters,
                        child: const Text('Clear All'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredClasses.length} classes found',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Classes List with Pagination at the Bottom (scrolls with content)
          Expanded(
            child: _filteredClasses.isEmpty
                ? _buildEmptyState()
                : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Class Cards
                ..._paginatedClasses.map((classItem) => ClassCard(
                  classItem: classItem,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassDetailPage(
                          classItem: classItem,
                        ),
                      ),
                    );
                  },
                )).toList(),

                // Pagination at the bottom of the list (scrolls with content)
                if (_filteredClasses.isNotEmpty && _totalPages > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                    child: Column(
                      children: [
                        // Page info
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Page $_currentPage of $_totalPages',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Scrollable page numbers
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Previous button
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: IconButton(
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
                              ),

                              // All page numbers
                              ...List.generate(_totalPages, (index) {
                                final pageNum = index + 1;
                                return _buildPageButton(pageNum);
                              }),

                              // Next button
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: IconButton(
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Add some bottom padding for better scrolling experience
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(String filterType) {
    List<String> options;
    String title;
    String selectedValue;

    switch (filterType) {
      case 'day':
        options = _days;
        title = 'Select Day';
        selectedValue = _selectedDay;
        break;
      case 'subject':
        options = _subjects;
        title = 'Select Subject';
        selectedValue = _selectedSubject;
        break;
      case 'grade':
        options = _grades;
        title = 'Select Grade';
        selectedValue = _selectedGrade;
        break;
      default:
        return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...options.map((option) {
                return ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        switch (filterType) {
                          case 'day':
                            _selectedDay = value!;
                            break;
                          case 'subject':
                            _selectedSubject = value!;
                            break;
                          case 'grade':
                            _selectedGrade = value!;
                            break;
                        }
                        _currentPage = 1;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.class_outlined,
            size: 80,
            color: AppColors.textDisabled.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No classes found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Clear Filters'),
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