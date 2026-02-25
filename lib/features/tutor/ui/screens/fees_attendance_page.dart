import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class FeesAttendancePage extends StatefulWidget {
  const FeesAttendancePage({Key? key}) : super(key: key);

  @override
  State<FeesAttendancePage> createState() => _FeesAttendancePageState();
}

class _FeesAttendancePageState extends State<FeesAttendancePage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Class details
  final Map<String, dynamic> _classDetails = {
    'name': 'Advanced Mathematics',
    'subject': 'Mathematics',
    'grade': 'Grade 10',
    'tutor': 'Dr. Sarah Johnson',
    'totalStudents': 24,
    'schedule': 'Monday',
    'monthlyFee': 2500,
  };

  // March 2024 days
  final List<Map<String, dynamic>> _marchDays = [
    {'date': 'Mon 01', 'status': 'completed'},
    {'date': 'Wed 03', 'status': 'completed'},
    {'date': 'Fri 05', 'status': 'completed'},
    {'date': 'Mon 08', 'status': 'completed'},
    {'date': 'Wed 10', 'status': 'completed'},
    {'date': 'Fri 12', 'status': 'completed'},
    {'date': 'Mon 15', 'status': 'today'},
    {'date': 'Wed 17', 'status': 'upcoming'},
    {'date': 'Fri 19', 'status': 'upcoming'},
  ];

  // Student data
  final List<Map<String, dynamic>> _allStudents = [
    {'rollNo': 'S001', 'name': 'Emma Watson', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S002', 'name': 'James Smith', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S003', 'name': 'Michael Brown', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S004', 'name': 'Sarah Johnson', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S005', 'name': 'David Wilson', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S006', 'name': 'Emily Davis', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S007', 'name': 'Daniel Martinez', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S008', 'name': 'Lisa Anderson', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S009', 'name': 'Robert Taylor', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S010', 'name': 'Jennifer Thomas', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S011', 'name': 'William Jackson', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S012', 'name': 'Mary White', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S013', 'name': 'Joseph Harris', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S014', 'name': 'Patricia Martin', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S015', 'name': 'Charles Thompson', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S016', 'name': 'Jessica Garcia', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S017', 'name': 'Thomas Robinson', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S018', 'name': 'Nancy Clark', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S019', 'name': 'Christopher Rodriguez', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S020', 'name': 'Karen Lewis', 'attendance': true, 'payment': false, 'paymentStatus': 'Pending'},
    {'rollNo': 'S021', 'name': 'Matthew Lee', 'attendance': false, 'payment': true, 'paymentStatus': 'Paid'},
    {'rollNo': 'S022', 'name': 'Betty Walker', 'attendance': true, 'payment': true, 'paymentStatus': 'Paid'},
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((student) {
      final searchMatch = _searchController.text.isEmpty ||
          student['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          student['rollNo'].toLowerCase().contains(_searchController.text.toLowerCase());

      bool paymentMatch = true;
      if (_selectedFilter == 'Paid') {
        paymentMatch = student['payment'] == true;
      } else if (_selectedFilter == 'Pending') {
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
  int get _presentCount => _filteredStudents.where((s) => s['attendance'] == true).length;
  int get _paidCount => _filteredStudents.where((s) => s['payment'] == true).length;
  int get _totalStudents => _filteredStudents.length;

  int get _totalAmount => 10;
  double get _attendancePercentage => _totalStudents > 0 ? (_presentCount / _totalStudents) * 100 : 0;
  double get _paymentPercentage => _totalStudents > 0 ? (_paidCount / _totalStudents) * 100 : 0;

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exporting data...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // TODO: Implement actual export logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fees & Attendance',
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
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Details
            _buildClassDetails(),
            const SizedBox(height: 24),

            // March 2024 Days
            _buildMarchDays(),
            const SizedBox(height: 24),

            // Stats Header with View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats Cards (Present, Paid, Pending)
            _buildStatsRow(),
            const SizedBox(height: 20),

            // Financial Stats Cards
            _buildStatsCards(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 20),

            // Search and Filters
            _buildSearchAndFilters(),
            const SizedBox(height: 20),

            // Student Table Header with Export
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
                _buildExportButton(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return InkWell(
      onTap: _exportData,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.download_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            const Text(
              'Export',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            const Color(0xFF4A6CF7).withOpacity(0.9),
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
          // Title Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.class_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _classDetails['name'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_classDetails['subject']} • ${_classDetails['grade']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Info Grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.person_outline,
                        'Tutor',
                        _classDetails['tutor'],
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.people_outline,
                        'Students',
                        '${_classDetails['totalStudents']} Enrolled',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.schedule,
                        'Schedule',
                        _classDetails['schedule'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Fee Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Fee',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rs. ${_classDetails['monthlyFee']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Edit Class',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarchDays() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'March 2024',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '12 Classes',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _marchDays.map((day) {
              Color bgColor;
              Color textColor;
              IconData? icon;

              switch(day['status']) {
                case 'completed':
                  bgColor = AppColors.success.withOpacity(0.1);
                  textColor = AppColors.success;
                  icon = Icons.check;
                  break;
                case 'today':
                  bgColor = AppColors.primary.withOpacity(0.1);
                  textColor = AppColors.primary;
                  icon = Icons.circle;
                  break;
                default:
                  bgColor = Colors.grey.shade50;
                  textColor = AppColors.textSecondary;
                  icon = null;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: textColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day['date'],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 4),
                      Icon(icon, size: 12, color: textColor),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem(AppColors.success, 'Completed'),
              const SizedBox(width: 12),
              _buildLegendItem(AppColors.primary, 'Today'),
              const SizedBox(width: 12),
              _buildLegendItem(AppColors.textSecondary, 'Upcoming'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Total Students',
            '$_totalStudents',
            Icons.people_alt,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Present',
            '$_presentCount',
            Icons.check_circle,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Pending',
            '${_totalStudents - _paidCount}',
            Icons.pending,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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

  Widget _buildStatsCards() {
    final totalReceivable = _totalStudents * _classDetails['monthlyFee'];
    final totalReceived = _paidCount * _classDetails['monthlyFee'];
    final totalPending = totalReceivable - totalReceived;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Receivable',
            amount: 'Rs ${totalReceivable.toStringAsFixed(0)}',
            subAmount: 'Rs ${totalPending.toStringAsFixed(0)} pending',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Received',
            amount: 'Rs ${totalReceived.toStringAsFixed(0)}',
            subAmount: '${_paidCount}/${_totalStudents} students',
            icon: Icons.payments_outlined,
            color: AppColors.success,
            backgroundColor: AppColors.success.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String amount,
    required String subAmount,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subAmount,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Mark Attendance'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Mark Payment'),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
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
          // Search Bar
          TextField(
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
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (value) {
              setState(() {
                _currentPage = 1;
              });
            },
          ),
          const SizedBox(height: 12),

          // Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Filter Chips
                _buildFilterChip('All'),
                const SizedBox(width: 6),
                _buildFilterChip('Paid'),
                const SizedBox(width: 6),
                _buildFilterChip('Pending'),
              ],
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
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 12,
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
                  Expanded(flex: 2, child: Text('Roll No', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 3, child: Text('Student Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Text('Attendance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
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
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: student['attendance']
                                    ? AppColors.success.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                student['attendance'] ? Icons.check : Icons.close,
                                color: student['attendance'] ? AppColors.success : Colors.red,
                                size: 14,
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