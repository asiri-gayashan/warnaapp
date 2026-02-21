import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/select_options.dart';
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
  final TextEditingController _gradeController = TextEditingController();

  String _selectedDay = 'All';
  String _selectedSubject = 'All';
  String _selectedGrade = 'All';
  String? _gradeError;

  int _currentPage = 1;
  final int _itemsPerPage = 4;

  bool _isLoading = true;
  String? _errorMessage;

  List<ClassModel> _allClasses = [];
  List<ClassModel> _filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }


  Future<void> _fetchClasses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5001/api/classes/"),
        headers: {
          'Content-Type': 'application/json',
          // Add your authorization header if needed
          // 'Authorization': 'Bearer your_token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response has the expected structure
        if (responseData['status'] == true && responseData.containsKey('data')) {
          List<dynamic> classesList = responseData['data'];

          setState(() {
            _allClasses = classesList.map((json) => _parseClassModel(json)).toList();
            _applyFilters();
            _isLoading = false;
          });

          print('Successfully loaded ${_allClasses.length} classes');
        } else {
          setState(() {
            _errorMessage = 'Invalid response format from server';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load classes. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error details: $e');
      setState(() {
        _errorMessage = 'Error connecting to server: $e';
        _isLoading = false;
      });
    }
  }

  ClassModel _parseClassModel(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id']?.toString() ?? '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      day: json['day'] ?? '',
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration']?.toString() ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? true,
      instituteId: json['instituteId']?.toString(),
      teacherId: json['teacherId']?.toString(),
      totalStudents: json['students'] != null ? (json['students'] as List).length : 0,
    );
  }





  void _applyFilters() {
    setState(() {
      _filteredClasses = _allClasses.where((classItem) {
        // Search filter - check multiple fields
        final searchTerm = _searchController.text.toLowerCase();
        final searchMatch = _searchController.text.isEmpty ||
            classItem.name.toLowerCase().contains(searchTerm) ||
            classItem.subject.toLowerCase().contains(searchTerm) ||
            classItem.location.toLowerCase().contains(searchTerm) ||
            (classItem.description.toLowerCase().contains(searchTerm)) ||
            (classItem.grade.toLowerCase().contains(searchTerm));

        // Day filter
        final dayMatch = _selectedDay == 'All' || classItem.day == _selectedDay;

        // Subject filter
        final subjectMatch = _selectedSubject == 'All' || classItem.subject == _selectedSubject;

        // Grade filter
        final gradeMatch = _selectedGrade == 'All' || classItem.grade == _selectedGrade;

        return searchMatch && dayMatch && subjectMatch && gradeMatch;
      }).toList();

      _currentPage = 1;
    });
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
      _gradeController.clear();
      _selectedDay = 'All';
      _selectedSubject = 'All';
      _selectedGrade = 'All';
      _gradeError = null;
      _applyFilters();
    });
  }

  void _validateGrade() {
    if (_selectedGrade == 'All' || _selectedGrade.isEmpty) {
      setState(() {
        _gradeError = 'Please select a grade';
      });
    } else {
      setState(() {
        _gradeError = null;
      });
    }
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
          IconButton(
            onPressed: _fetchClasses,
            icon: const Icon(Icons.sync, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : Column(
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
                      hintText: 'Search classes by name, subject, or location...',
                      hintStyle: TextStyle(color: AppColors.textDisabled),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _applyFilters();
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Advanced Filter Chips
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
                if (_filteredClasses.isNotEmpty)
                  Text(
                    'Showing ${_paginatedClasses.length} of ${_filteredClasses.length}',
                    style: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // Classes List with Pagination
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

                // Pagination
                if (_filteredClasses.isNotEmpty && _totalPages > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                    child: Column(
                      children: [
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              ...List.generate(_totalPages, (index) {
                                final pageNum = index + 1;
                                return _buildPageButton(pageNum);
                              }),
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
    bool isActive = !label.contains('All');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
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
        options = ['All', ...SelectOptions.daysList];
        title = 'Select Day';
        selectedValue = _selectedDay;
        break;
      case 'subject':
        options = ['All', ...SelectOptions.subjects];
        title = 'Select Subject';
        selectedValue = _selectedSubject;
        break;
      case 'grade':
        options = ['All', ...SelectOptions.gradesList];
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
                            if (value != 'All') {
                              _gradeController.text = value!;
                            } else {
                              _gradeController.clear();
                            }
                            _validateGrade();
                            break;
                        }
                        _applyFilters();
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Failed to load classes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchClasses,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
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
            _allClasses.isEmpty
                ? 'No classes available. Pull to refresh.'
                : 'Try adjusting your search or filters',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (_allClasses.isNotEmpty) ...[
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
          ] else ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchClasses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Refresh'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
}