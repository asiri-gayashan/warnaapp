import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class InstituteFinancePage extends StatefulWidget {
  const InstituteFinancePage({Key? key}) : super(key: key);

  @override
  State<InstituteFinancePage> createState() => _InstituteFinancePageState();
}

class _InstituteFinancePageState extends State<InstituteFinancePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPeriod = 'March 2024';
  bool _showAllClasses = false;

  // Sample periods
  final List<String> _periods = [
    'March 2024',
    'February 2024',
    'January 2024',
    'December 2023',
  ];

  // Sample class financial data
  final List<Map<String, dynamic>> _classesData = [
    {
      'className': 'Advanced Mathematics - Grade 10',
      'totalRevenue': 37500,
      'commission': 5625,
      'receivedAmount': 30000,
      'pendingAmount': 7500,
      'teacherPaid': true,
      'teacherName': 'Dr. John Smith',
      'studentCount': 15,
      'paidStudents': 12,
      'notPaidStudents': 3,
    },
    {
      'className': 'Physics Fundamentals - Grade 11',
      'totalRevenue': 30000,
      'commission': 4500,
      'receivedAmount': 22500,
      'pendingAmount': 7500,
      'teacherPaid': false,
      'teacherName': 'Prof. Sarah Johnson',
      'studentCount': 12,
      'paidStudents': 9,
      'notPaidStudents': 3,
    },   {
      'className': 'Chemistry Lab - Grade 10',
      'totalRevenue': 25000,
      'commission': 3750,
      'receivedAmount': 25000,
      'pendingAmount': 0,
      'teacherPaid': true,
      'teacherName': 'Dr. Michael Chen',
      'studentCount': 10,
      'paidStudents': 10,
      'notPaidStudents': 0,
    },
    {
      'className': 'English Literature - Grade 9',
      'totalRevenue': 45000,
      'commission': 6750,
      'receivedAmount': 36000,
      'pendingAmount': 9000,
      'teacherPaid': true,
      'teacherName': 'Prof. Emily Williams',
      'studentCount': 18,
      'paidStudents': 14,
      'notPaidStudents': 4,
    },
    {
      'className': 'Computer Science - Grade 11',
      'totalRevenue': 32500,
      'commission': 4875,
      'receivedAmount': 26000,
      'pendingAmount': 6500,
      'teacherPaid': false,
      'teacherName': 'Dr. David Brown',
      'studentCount': 13,
      'paidStudents': 10,
      'notPaidStudents': 3,
    },
    {
      'className': 'Biology - Grade 10',
      'totalRevenue': 27500,
      'commission': 4125,
      'receivedAmount': 22000,
      'pendingAmount': 5500,
      'teacherPaid': true,
      'teacherName': 'Prof. Lisa Davis',
      'studentCount': 11,
      'paidStudents': 8,
      'notPaidStudents': 3,
    },
    {
      'className': 'Advanced Mathematics - Grade 11',
      'totalRevenue': 40000,
      'commission': 6000,
      'receivedAmount': 32000,
      'pendingAmount': 8000,
      'teacherPaid': false,
      'teacherName': 'Dr. Robert Wilson',
      'studentCount': 16,
      'paidStudents': 12,
      'notPaidStudents': 4,
    },
    {
      'className': 'Physics - Grade 10',
      'totalRevenue': 35000,
      'commission': 5250,
      'receivedAmount': 28000,
      'pendingAmount': 7000,
      'teacherPaid': true,
      'teacherName': 'Prof. Jennifer Lee',
      'studentCount': 14,
      'paidStudents': 11,
      'notPaidStudents': 3,
    },
  ];

  // Calculate totals
  int get _totalRevenue => _classesData.fold(0, (sum, item) => sum + (item['totalRevenue'] as int));
  int get _totalCommission => _classesData.fold(0, (sum, item) => sum + (item['commission'] as int));
  int get _totalReceived => _classesData.fold(0, (sum, item) => sum + (item['receivedAmount'] as int));
  int get _totalPending => _classesData.fold(0, (sum, item) => sum + (item['pendingAmount'] as int));
  int get _totalReceivable => _totalRevenue;

  int get _totalStudents => _classesData.fold(0, (sum, item) => sum + (item['studentCount'] as int));
  int get _totalPaidStudents => _classesData.fold(0, (sum, item) => sum + (item['paidStudents'] as int));
  int get _totalNotPaidStudents => _classesData.fold(0, (sum, item) => sum + (item['notPaidStudents'] as int));

  int get _teacherPaidCount => _classesData.where((c) => c['teacherPaid'] == true).length;
  int get _teacherUnpaidCount => _classesData.where((c) => c['teacherPaid'] == false).length;

  List<Map<String, dynamic>> get _displayClasses {
    if (_showAllClasses) {
      return _classesData;
    }
    return _classesData.take(4).toList();
  }

  String get _netProfit {
    int profit = _totalRevenue - _totalCommission;
    return 'Rs ${profit.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Finance Overview',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Period Selector
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 18),
                items: _periods.map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(
                      period,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Summary Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildSummaryCard(
                  'Last Month Revenue',
                  'Rs ${_totalRevenue}',
                  Icons.trending_up,
                  AppColors.primary,
                  '${_totalRevenue ~/ 1000}K',
                ),
                _buildSummaryCard(
                  'Total Commission',
                  'Rs ${_totalCommission}',
                  Icons.percent,
                  Colors.orange,
                  '${(_totalCommission / _totalRevenue * 100).toStringAsFixed(1)}%',
                ),
                _buildSummaryCard(
                  'Total Receivable',
                  'Rs ${_totalReceivable}',
                  Icons.account_balance_wallet,
                  Colors.purple,
                  '${_totalReceivable ~/ 1000}K',
                ),
                _buildSummaryCard(
                  'Total Received',
                  'Rs ${_totalReceived}',
                  Icons.payments,
                  AppColors.success,
                  '${(_totalReceived / _totalRevenue * 100).toStringAsFixed(1)}%',
                ),
                _buildSummaryCard(
                  'Total Pending',
                  'Rs ${_totalPending}',
                  Icons.pending,
                  Colors.red,
                  '${(_totalPending / _totalRevenue * 100).toStringAsFixed(1)}%',
                ),
                _buildSummaryCard(
                  'Net Profit',
                  _netProfit,
                  Icons.account_balance,
                  Colors.teal,
                  'After commission',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Student Payment Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Student Payment Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStudentStat(
                          'Total Students',
                          '$_totalStudents',
                          Icons.people,
                          AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: _buildStudentStat(
                          'Paid',
                          '$_totalPaidStudents',
                          Icons.check_circle,
                          AppColors.success,
                        ),
                      ),
                      Expanded(
                        child: _buildStudentStat(
                          'Not Paid',
                          '$_totalNotPaidStudents',
                          Icons.pending,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _totalPaidStudents / _totalStudents,
                      backgroundColor: Colors.grey.shade200,
                      color: AppColors.success,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(_totalPaidStudents / _totalStudents * 100).toStringAsFixed(1)}% paid',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${(_totalNotPaidStudents / _totalStudents * 100).toStringAsFixed(1)}% pending',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Teacher Payment Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Teacher Payment Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTeacherStat(
                          'Paid',
                          '$_teacherPaidCount',
                          Icons.check_circle,
                          AppColors.success,
                        ),
                      ),
                      Expanded(
                        child: _buildTeacherStat(
                          'Unpaid',
                          '$_teacherUnpaidCount',
                          Icons.pending,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Process Payments'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Classes Financial Overview Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Classes Financial Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllClasses = !_showAllClasses;
                    });
                  },
                  child: Text(_showAllClasses ? 'Show Less' : 'View All'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Class Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _displayClasses.length,
              itemBuilder: (context, index) {
                final classData = _displayClasses[index];
                return _buildClassCard(classData);
              },
            ),

            const SizedBox(height: 16),

            // Export Options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF Report'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Excel Export'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.success,
                        side: BorderSide(color: AppColors.success),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
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
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Name and Teacher
          Row(
            children: [
              Expanded(
                child: Text(
                  classData['className'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: classData['teacherPaid']
                      ? AppColors.success.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      classData['teacherPaid'] ? Icons.check_circle : Icons.pending,
                      size: 12,
                      color: classData['teacherPaid'] ? AppColors.success : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      classData['teacherPaid'] ? 'Teacher Paid' : 'Teacher Unpaid',
                      style: TextStyle(
                        fontSize: 10,
                        color: classData['teacherPaid'] ? AppColors.success : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            classData['teacherName'],
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          // Financial Row
          Row(
            children: [
              Expanded(
                child: _buildClassMetric(
                  'Total Revenue',
                  'Rs ${classData['totalRevenue']}',
                  Icons.account_balance,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildClassMetric(
                  'Commission',
                  'Rs ${classData['commission']}',
                  Icons.percent,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildClassMetric(
                  'Received',
                  'Rs ${classData['receivedAmount']}',
                  Icons.payments,
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildClassMetric(
                  'Pending',
                  'Rs ${classData['pendingAmount']}',
                  Icons.pending,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Student Payment Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${classData['paidStudents']} Paid',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${classData['notPaidStudents']} Not Paid',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${classData['studentCount']} Students',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassMetric(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}