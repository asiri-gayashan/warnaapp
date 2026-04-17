import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/shared/widgets/new/month_year_picker.dart';
import 'package:warna_app/shared/widgets/new/stat_card.dart';
import 'package:warna_app/shared/widgets/new/selection_header_card.dart';
import 'package:warna_app/shared/widgets/new/custom_pagination.dart';

class MarkPaymentPage extends StatefulWidget {
  const MarkPaymentPage({Key? key}) : super(key: key);

  @override
  State<MarkPaymentPage> createState() => _MarkPaymentPageState();
}

class _MarkPaymentPageState extends State<MarkPaymentPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedClass;
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All'; // All, Paid, Unpaid
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

  // Sample students with payment data
  final List<Map<String, dynamic>> _allStudents = [
    {
      'rollNo': 'S001',
      'name': 'Emma Watson',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-01',
    },
    {
      'rollNo': 'S002',
      'name': 'James Smith',
      'payment': false,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': null,
    },
    {
      'rollNo': 'S003',
      'name': 'Michael Brown',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-02',
    },
    {
      'rollNo': 'S004',
      'name': 'Sarah Johnson',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-01',
    },
    {
      'rollNo': 'S005',
      'name': 'David Wilson',
      'payment': false,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': null,
    },
    {
      'rollNo': 'S006',
      'name': 'Emily Davis',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-03',
    },
    {
      'rollNo': 'S007',
      'name': 'Daniel Martinez',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-01',
    },
    {
      'rollNo': 'S008',
      'name': 'Lisa Anderson',
      'payment': false,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': null,
    },
    {
      'rollNo': 'S009',
      'name': 'Robert Taylor',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-02',
    },
    {
      'rollNo': 'S010',
      'name': 'Jennifer Thomas',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-01',
    },
    {
      'rollNo': 'S011',
      'name': 'William Jackson',
      'payment': false,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': null,
    },
    {
      'rollNo': 'S012',
      'name': 'Mary White',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-03',
    },
    {
      'rollNo': 'S013',
      'name': 'Joseph Harris',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-01',
    },
    {
      'rollNo': 'S014',
      'name': 'Patricia Martin',
      'payment': false,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': null,
    },
    {
      'rollNo': 'S015',
      'name': 'Charles Thompson',
      'payment': true,
      'amount': 2500,
      'dueDate': '2024-03-15',
      'paymentDate': '2024-03-02',
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
          );

      // Payment status filter
      bool paymentMatch = true;
      if (_selectedFilter == 'Paid') {
        paymentMatch = student['payment'] == true;
      } else if (_selectedFilter == 'Unpaid') {
        paymentMatch = student['payment'] == false;
      }

      return searchMatch && paymentMatch;
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
  int get _paidCount =>
      _filteredStudents.where((s) => s['payment'] == true).length;
  int get _unpaidCount =>
      _filteredStudents.where((s) => s['payment'] == false).length;
  int get _totalAmount => _filteredStudents.length * 2500;
  int get _collectedAmount => _paidCount * 2500;
  int get _pendingAmount => _unpaidCount * 2500;

  void _toggleAllPayment() {
    setState(() {
      _selectAll = !_selectAll;
      for (var student in _paginatedStudents) {
        student['payment'] = _selectAll;
      }
    });
  }

  void _toggleStudentPayment(int index) {
    setState(() {
      _paginatedStudents[index]['payment'] =
          !_paginatedStudents[index]['payment'];
      // Update payment date
      if (_paginatedStudents[index]['payment']) {
        _paginatedStudents[index]['paymentDate'] =
            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
      } else {
        _paginatedStudents[index]['paymentDate'] = null;
      }

      // Check if all are selected to update selectAll
      _selectAll = _paginatedStudents.every((s) => s['payment'] == true);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _savePayments() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payments saved!'),
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
          ' Institute Mark Payments',
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
              title: 'Select Class & Month',
              classHint: 'Select Class',
              classes: _classes,
              selectedClass: _selectedClass,
              onClassChanged: (newValue) =>
                  setState(() => _selectedClass = newValue),
              dateText:
                  '${_selectedDate.year} - ${_selectedDate.month.toString().padLeft(2, '0')}',
              dateIcon: Icons.calendar_month,
              onDateTap: () => _selectDate(context),
            ),

            const SizedBox(height: 24),
            // Financial Stats Cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total Amount',
                    value: 'Rs $_totalAmount',
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Collected',
                    value: 'Rs $_collectedAmount',
                    icon: Icons.payments_outlined,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Pending',
                    value: 'Rs $_pendingAmount',
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Student Count Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_paidCount Paid',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.pending,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_unpaidCount Not Paid',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
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

                  // Filter Chips
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Paid'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Unpaid'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Student List Header with Select All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student Payments',
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
                      onTap: _toggleAllPayment,
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
                      onPressed: _selectedClass == null ? null : _savePayments,
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
                        'Save Payments',
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _currentPage = 1;
          _selectAll = false; // Reset select all when filter changes
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
                      'Amount',
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
                        child: Text(
                          'Rs ${student['amount']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
                                color: student['payment']
                                    ? AppColors.success
                                    : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                student['payment'] ? 'Paid' : 'Not Paid',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: student['payment']
                                      ? AppColors.success
                                      : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => _toggleStudentPayment(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: student['payment']
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: student['payment']
                                    ? AppColors.success
                                    : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            child: student['payment']
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
