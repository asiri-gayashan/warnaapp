import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class InstituteMarkPaymentPage extends StatefulWidget {
  const InstituteMarkPaymentPage({Key? key}) : super(key: key);

  @override
  State<InstituteMarkPaymentPage> createState() => _InstituteMarkPaymentPageState();
}

class _InstituteMarkPaymentPageState extends State<InstituteMarkPaymentPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedTeacher;
  DateTime _selectedMonth = DateTime.now();
  String _selectedFilter = 'All'; // All, Paid, Unpaid
  bool _selectAll = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Sample teachers
  final List<String> _teachers = [
    'Dr. John Smith - Mathematics',
    'Prof. Sarah Johnson - Physics',
    'Dr. Michael Chen - Chemistry',
    'Prof. Emily Williams - English',
    'Dr. David Brown - Computer Science',
    'Prof. Lisa Davis - Biology',
  ];

  // Sample teachers with payment data
  final List<Map<String, dynamic>> _allTeachers = [
    {
      'id': 'T001',
      'name': 'Dr. John Smith',
      'subject': 'Mathematics',
      'payment': true,
      'amount': 45000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-15',
      'bankAccount': '1234-5678-9012',
      'month': 'March 2024',
    },
    {
      'id': 'T002',
      'name': 'Prof. Sarah Johnson',
      'subject': 'Physics',
      'payment': false,
      'amount': 52000,
      'dueDate': '2024-03-31',
      'paymentDate': null,
      'bankAccount': '2345-6789-0123',
      'month': 'March 2024',
    },
    {
      'id': 'T003',
      'name': 'Dr. Michael Chen',
      'subject': 'Chemistry',
      'payment': true,
      'amount': 48000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-14',
      'bankAccount': '3456-7890-1234',
      'month': 'March 2024',
    },
    {
      'id': 'T004',
      'name': 'Prof. Emily Williams',
      'subject': 'English',
      'payment': true,
      'amount': 41000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-16',
      'bankAccount': '4567-8901-2345',
      'month': 'March 2024',
    },
    {
      'id': 'T005',
      'name': 'Dr. David Brown',
      'subject': 'Computer Science',
      'payment': false,
      'amount': 55000,
      'dueDate': '2024-03-31',
      'paymentDate': null,
      'bankAccount': '5678-9012-3456',
      'month': 'March 2024',
    },
    {
      'id': 'T006',
      'name': 'Prof. Lisa Davis',
      'subject': 'Biology',
      'payment': true,
      'amount': 43000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-15',
      'bankAccount': '6789-0123-4567',
      'month': 'March 2024',
    },
    {
      'id': 'T007',
      'name': 'Dr. Robert Wilson',
      'subject': 'Mathematics',
      'payment': true,
      'amount': 47000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-14',
      'bankAccount': '7890-1234-5678',
      'month': 'March 2024',
    },
    {
      'id': 'T008',
      'name': 'Prof. Jennifer Lee',
      'subject': 'Physics',
      'payment': false,
      'amount': 50000,
      'dueDate': '2024-03-31',
      'paymentDate': null,
      'bankAccount': '8901-2345-6789',
      'month': 'March 2024',
    },
    {
      'id': 'T009',
      'name': 'Dr. James Taylor',
      'subject': 'Chemistry',
      'payment': true,
      'amount': 46000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-13',
      'bankAccount': '9012-3456-7890',
      'month': 'March 2024',
    },
    {
      'id': 'T010',
      'name': 'Prof. Maria Garcia',
      'subject': 'English',
      'payment': false,
      'amount': 42000,
      'dueDate': '2024-03-31',
      'paymentDate': null,
      'bankAccount': '0123-4567-8901',
      'month': 'March 2024',
    },
    {
      'id': 'T011',
      'name': 'Dr. Thomas Anderson',
      'subject': 'Computer Science',
      'payment': true,
      'amount': 53000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-15',
      'bankAccount': '1234-5678-9012',
      'month': 'March 2024',
    },
    {
      'id': 'T012',
      'name': 'Prof. Patricia White',
      'subject': 'Biology',
      'payment': true,
      'amount': 44000,
      'dueDate': '2024-03-31',
      'paymentDate': '2024-03-12',
      'bankAccount': '2345-6789-0123',
      'month': 'March 2024',
    },
  ];

  List<Map<String, dynamic>> get _filteredTeachers {
    return _allTeachers.where((teacher) {
      // Teacher filter
      final teacherMatch = _selectedTeacher == null ||
          teacher['name'].contains(_selectedTeacher!.split(' - ')[0]);

      // Search filter
      final searchMatch = _searchController.text.isEmpty ||
          teacher['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          teacher['id'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          teacher['subject'].toLowerCase().contains(_searchController.text.toLowerCase());

      // Payment status filter
      bool paymentMatch = true;
      if (_selectedFilter == 'Paid') {
        paymentMatch = teacher['payment'] == true;
      } else if (_selectedFilter == 'Unpaid') {
        paymentMatch = teacher['payment'] == false;
      }

      return teacherMatch && searchMatch && paymentMatch;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedTeachers {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredTeachers.length) return [];
    return _filteredTeachers.sublist(
      startIndex,
      endIndex > _filteredTeachers.length ? _filteredTeachers.length : endIndex,
    );
  }

  int get _totalPages => (_filteredTeachers.length / _itemsPerPage).ceil();
  int get _paidCount => _filteredTeachers.where((t) => t['payment'] == true).length;
  int get _unpaidCount => _filteredTeachers.where((t) => t['payment'] == false).length;
  int get _totalAmount => _filteredTeachers.fold(0, (sum, item) => sum + (item['amount'] as int));
  int get _paidAmount => _filteredTeachers.where((t) => t['payment'] == true).fold(0, (sum, item) => sum + (item['amount'] as int));
  int get _pendingAmount => _totalAmount - _paidAmount;

  void _toggleAllPayment() {
    setState(() {
      _selectAll = !_selectAll;
      for (var teacher in _paginatedTeachers) {
        teacher['payment'] = _selectAll;
      }
      _updatePaymentStatus();
    });
  }

  void _toggleTeacherPayment(int index) {
    setState(() {
      _paginatedTeachers[index]['payment'] = !_paginatedTeachers[index]['payment'];

      // Update payment date
      if (_paginatedTeachers[index]['payment']) {
        _paginatedTeachers[index]['paymentDate'] =
        '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}-${_selectedMonth.day.toString().padLeft(2, '0')}';
      } else {
        _paginatedTeachers[index]['paymentDate'] = null;
      }

      // Check if all are selected to update selectAll
      _selectAll = _paginatedTeachers.every((t) => t['payment'] == true);
    });
  }

  void _updatePaymentStatus() {
    _selectAll = _paginatedTeachers.every((t) => t['payment'] == true);
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
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
    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  void _savePayments() {
    if (_selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a teacher first'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final paidCount = _paginatedTeachers.where((t) => t['payment'] == true).length;
    final paidAmount = _paginatedTeachers.where((t) => t['payment'] == true).fold(0, (sum, item) => sum + (item['amount'] as int));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ Payments saved for $paidCount teachers (Rs $paidAmount)'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get _monthYearText {
    return '${_selectedMonth.year} - ${_selectedMonth.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Institute - Teacher Payments',
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
                    'Select Teacher & Month',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Teacher Selector
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
                          'Select Teacher',
                          style: TextStyle(color: Colors.white70),
                        ),
                        value: _selectedTeacher,
                        dropdownColor: AppColors.primary,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _teachers.map((String teacherName) {
                          return DropdownMenuItem<String>(
                            value: teacherName,
                            child: Text(
                              teacherName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTeacher = newValue;
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Month & Year Selector
                  GestureDetector(
                    onTap: () => _selectMonthYear(context),
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
                          const Icon(Icons.calendar_month, color: Colors.white, size: 18),
                          const SizedBox(width: 12),
                          Text(
                            _monthYearText,
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

            // Financial Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Salary',
                    'Rs $_totalAmount',
                    Icons.account_balance_wallet_outlined,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Paid',
                    'Rs $_paidAmount',
                    Icons.payments_outlined,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    'Rs $_pendingAmount',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Teacher Count Stats
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
                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
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
                        const Icon(Icons.pending, color: Colors.orange, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '$_unpaidCount Unpaid',
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
                      hintText: 'Search by name, ID or subject...',
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

            // Teacher List Header with Select All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Teacher Payments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_filteredTeachers.isNotEmpty)
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

            // Teacher Table
            _filteredTeachers.isEmpty
                ? _buildEmptyState()
                : _buildTeacherTable(),

            const SizedBox(height: 20),

            // Pagination
            if (_filteredTeachers.isNotEmpty && _totalPages > 1)
              _buildPagination(),

            const SizedBox(height: 20),

            // Summary and Save Button
            if (_selectedTeacher != null)
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
                    // Summary Row
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_paidCount of ${_filteredTeachers.length} teachers paid',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Rs $_paidAmount / Rs $_totalAmount',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePayments,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Process Payments',
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

  Widget _buildTeacherTable() {
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
                  Expanded(flex: 2, child: Text('ID', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 3, child: Text('Teacher Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Text('Subject', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 1, child: Text('Mark', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                ],
              ),
            ),

            // Table Body
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paginatedTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _paginatedTeachers[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.all(14),
                  color: isEven ? Colors.white : AppColors.background.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          teacher['id'],
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            if (teacher['paymentDate'] != null)
                              Text(
                                'Paid: ${teacher['paymentDate']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.success,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          teacher['subject'],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rs ${teacher['amount']}',
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
                                color: teacher['payment'] ? AppColors.success : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                teacher['payment'] ? 'Paid' : 'Not Paid',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: teacher['payment'] ? AppColors.success : Colors.orange,
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
                          onTap: () => _toggleTeacherPayment(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: teacher['payment']
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: teacher['payment']
                                    ? AppColors.success
                                    : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            child: teacher['payment']
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
                    _selectAll = false; // Reset select all on page change
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
                _selectAll = false; // Reset select all on page change
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.payments_outlined,
            size: 50,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 16),
          const Text(
            'No teachers found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty || _selectedFilter != 'All'
                ? 'Try adjusting your search or filters'
                : 'Select a teacher to view payment details',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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