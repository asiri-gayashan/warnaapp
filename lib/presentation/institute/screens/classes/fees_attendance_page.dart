import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/institute/screens/student/mark_payment_page.dart';
import 'package:warna_app/presentation/institute/screens/student/mark_attendance_page.dart';
import 'package:warna_app/shared/widgets/new/fees_class_details_card.dart';
import 'package:warna_app/shared/widgets/new/attendance_month_schedule_card.dart';
import 'package:warna_app/shared/widgets/new/stats_overview_row.dart';
import 'package:warna_app/shared/widgets/new/financial_stats_row.dart';
import 'package:warna_app/shared/widgets/new/student_search_filter.dart';
import 'package:warna_app/shared/widgets/new/student_list_table.dart';
import 'package:warna_app/shared/widgets/new/numbered_pagination.dart';
import 'package:warna_app/shared/widgets/new/export_button.dart';

class FeesAttendancePage extends StatefulWidget {
  const FeesAttendancePage({Key? key}) : super(key: key);

  @override
  State<FeesAttendancePage> createState() => _FeesAttendancePageState();
}

class _FeesAttendancePageState extends State<FeesAttendancePage> {
  final TextEditingController _searchController = TextEditingController();
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
    {
      'rollNo': 'S001',
      'name': 'Emma Watson',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S002',
      'name': 'James Smith',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S003',
      'name': 'Michael Brown',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S004',
      'name': 'Sarah Johnson',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S005',
      'name': 'David Wilson',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S006',
      'name': 'Emily Davis',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S007',
      'name': 'Daniel Martinez',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S008',
      'name': 'Lisa Anderson',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S009',
      'name': 'Robert Taylor',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S010',
      'name': 'Jennifer Thomas',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S011',
      'name': 'William Jackson',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S012',
      'name': 'Mary White',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S013',
      'name': 'Joseph Harris',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S014',
      'name': 'Patricia Martin',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S015',
      'name': 'Charles Thompson',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S016',
      'name': 'Jessica Garcia',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S017',
      'name': 'Thomas Robinson',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S018',
      'name': 'Nancy Clark',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S019',
      'name': 'Christopher Rodriguez',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S020',
      'name': 'Karen Lewis',
      'attendance': true,
      'payment': false,
      'paymentStatus': 'Pending',
    },
    {
      'rollNo': 'S021',
      'name': 'Matthew Lee',
      'attendance': false,
      'payment': true,
      'paymentStatus': 'Paid',
    },
    {
      'rollNo': 'S022',
      'name': 'Betty Walker',
      'attendance': true,
      'payment': true,
      'paymentStatus': 'Paid',
    },
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _allStudents.where((student) {
      final searchMatch =
          _searchController.text.isEmpty ||
          student['name'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student['rollNo'].toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

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
  int get _presentCount =>
      _filteredStudents.where((s) => s['attendance'] == true).length;
  int get _paidCount =>
      _filteredStudents.where((s) => s['payment'] == true).length;
  int get _totalStudents => _filteredStudents.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fees & Attendance Institute',
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
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
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
            FeesClassDetailsCard(
              classDetails: _classDetails,
              onEdit: () {
                // Handle edit class
              },
            ),
            const SizedBox(height: 24),

            // March 2024 Days
            AttendanceMonthScheduleCard(
              monthYear: 'March 2024',
              totalClasses: 12,
              marchDays: _marchDays,
            ),
            const SizedBox(height: 24),

            // Stats Header with View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
            StatsOverviewRow(
              totalStudents: _totalStudents,
              presentCount: _presentCount,
              paidCount: _paidCount,
            ),
            const SizedBox(height: 20),

            // Financial Stats Cards
            FinancialStatsRow(
              totalStudents: _totalStudents,
              paidCount: _paidCount,
              monthlyFee: _classDetails['monthlyFee'],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarkAttendancePage(),
                        ),
                      );
                    },
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarkPaymentPage(),
                        ),
                      );
                    },
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
            ),
            const SizedBox(height: 20),

            // Search and Filters
            StudentSearchFilter(
              searchController: _searchController,
              selectedFilter: _selectedFilter,
              onFilterChanged: (label) {
                setState(() {
                  _selectedFilter = label;
                  _currentPage = 1;
                });
              },
              onSearchChanged: (value) {
                setState(() {
                  _currentPage = 1;
                });
              },
              onClearSearch: () {
                setState(() {
                  _searchController.clear();
                  _currentPage = 1;
                });
              },
            ),
            const SizedBox(height: 20),

            // Student Table Header with Export
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ExportButton(onTap: _showExportModal),
              ],
            ),
            const SizedBox(height: 12),

            // Student Table
            StudentListTable(paginatedStudents: _paginatedStudents),
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
          ],
        ),
      ),
    );
  }

  void _showExportModal() {
    String selectedMonth = 'March';
    String selectedYear = '2024';
    String selectedDate = '15';
    String selectedPaymentStatus = 'All';
    bool includeAttendance = true;

    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final List<String> years = ['2023', '2024', '2025'];

    final List<String> dates = List.generate(
      31,
      (index) => (index + 1).toString(),
    );

    final List<String> paymentStatuses = ['All', 'Paid', 'Unpaid', 'Pending'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Export Data',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Divider(color: Colors.grey.shade200, height: 1),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month Selection
                          const Text(
                            'Select Month',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                value: selectedMonth,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textSecondary,
                                ),
                                items: months.map((month) {
                                  return DropdownMenuItem(
                                    value: month,
                                    child: Text(month),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMonth = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Year Selection
                          const Text(
                            'Select Year',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                value: selectedYear,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textSecondary,
                                ),
                                items: years.map((year) {
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Date Selection
                          const Text(
                            'Select Date (Optional)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Leave empty for full month report',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                value: selectedDate,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textSecondary,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: 'All',
                                    child: Text('All Dates'),
                                  ),
                                  ...dates.map((date) {
                                    return DropdownMenuItem(
                                      value: date,
                                      child: Text(date),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedDate = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Payment Status Filter
                          const Text(
                            'Payment Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                value: selectedPaymentStatus,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textSecondary,
                                ),
                                items: paymentStatuses.map((status) {
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentStatus = value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Include Attendance Toggle
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Include Attendance',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Add attendance data to export',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      includeAttendance = !includeAttendance;
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: includeAttendance
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      alignment: includeAttendance
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        margin: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
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
                  ),

                  // Bottom Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: BorderSide(color: Colors.grey.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _performExport(
                                month: selectedMonth,
                                year: selectedYear,
                                date: selectedDate,
                                paymentStatus: selectedPaymentStatus,
                                includeAttendance: includeAttendance,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Export'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _performExport({
    required String month,
    required String year,
    required String date,
    required String paymentStatus,
    required bool includeAttendance,
  }) {
    String dateFilter = date == 'All' ? 'all dates' : 'date $date';
    String attendanceText = includeAttendance
        ? 'with attendance'
        : 'without attendance';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exporting data for $month $year ($dateFilter), Payment: $paymentStatus, $attendanceText',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // TODO: Implement actual export logic here
    // You can add CSV/PDF generation based on the selected filters
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
