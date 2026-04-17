import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class InstituteFinancePage extends StatefulWidget {
  const InstituteFinancePage({Key? key}) : super(key: key);

  @override
  State<InstituteFinancePage> createState() => _InstituteFinancePageState();
}

class _InstituteFinancePageState extends State<InstituteFinancePage> {
  String _selectedTab = 'summary';
  String _selectedPeriod = 'March 2024';
  bool _showAllClasses = false;

  final List<String> _periods = [
    'March 2024',
    'February 2024',
    'January 2024',
    'December 2023',
  ];

  final List<Map<String, dynamic>> _classesData = [
    {
      'name': 'Advanced Mathematics',
      'grade': 'Grade 10',
      'teacher': 'Dr. John Smith',
      'teacherPaid': true,
      'revenue': 37500,
      'commission': 5625,
      'received': 30000,
      'pending': 7500,
      'paidS': 12,
      'unpaidS': 3,
      'total': 15,
    },
    {
      'name': 'Physics Fundamentals',
      'grade': 'Grade 11',
      'teacher': 'Prof. Sarah Johnson',
      'teacherPaid': false,
      'revenue': 30000,
      'commission': 4500,
      'received': 22500,
      'pending': 7500,
      'paidS': 9,
      'unpaidS': 3,
      'total': 12,
    },
    {
      'name': 'Chemistry Lab',
      'grade': 'Grade 10',
      'teacher': 'Dr. Michael Chen',
      'teacherPaid': true,
      'revenue': 25000,
      'commission': 3750,
      'received': 25000,
      'pending': 0,
      'paidS': 10,
      'unpaidS': 0,
      'total': 10,
    },
    {
      'name': 'English Literature',
      'grade': 'Grade 9',
      'teacher': 'Prof. Emily Williams',
      'teacherPaid': true,
      'revenue': 45000,
      'commission': 6750,
      'received': 36000,
      'pending': 9000,
      'paidS': 14,
      'unpaidS': 4,
      'total': 18,
    },
  ];

  // Calculations
  int get _totalRevenue => _classesData.fold(0, (sum, item) => sum + (item['revenue'] as int));
  int get _totalCommission => _classesData.fold(0, (sum, item) => sum + (item['commission'] as int));
  int get _totalReceived => _classesData.fold(0, (sum, item) => sum + (item['received'] as int));
  int get _totalPending => _classesData.fold(0, (sum, item) => sum + (item['pending'] as int));
  int get _totalReceivable => _totalRevenue;
  int get _netProfit => _totalRevenue - _totalCommission;
  
  int get _totalStudents => _classesData.fold(0, (sum, item) => sum + (item['total'] as int));
  int get _totalPaidStudents => _classesData.fold(0, (sum, item) => sum + (item['paidS'] as int));
  int get _totalNotPaidStudents => _classesData.fold(0, (sum, item) => sum + (item['unpaidS'] as int));
  
  int get _paidTeachers => _classesData.where((c) => c['teacherPaid'] == true).length;
  int get _unpaidTeachers => _classesData.where((c) => c['teacherPaid'] == false).length;

  double get _paymentPercentage => _totalStudents > 0 ? (_totalPaidStudents / _totalStudents) * 100 : 0;
  double get _receivedPercentage => _totalRevenue > 0 ? (_totalReceived / _totalRevenue) * 100 : 0;

  String formatRs(int amount) => 'Rs ${amount.toStringAsFixed(0)}';

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
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 18),
                items: _periods.map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedPeriod = newValue!);
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Card
            _buildHeroCard(),
            const SizedBox(height: 20),

            // Tabs
            _buildTabs(),
            const SizedBox(height: 20),

            // Tab Content
            if (_selectedTab == 'summary') _buildSummaryTab(),
            if (_selectedTab == 'classes') _buildClassesTab(),
            if (_selectedTab == 'teachers') _buildTeachersTab(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Total Revenue
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRs(_totalRevenue),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              _buildProgressRing(_receivedPercentage, 64),
            ],
          ),
          const SizedBox(height: 16),

          // Sub stats
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                _buildSubStat('Received', formatRs(_totalReceived), AppColors.success),
                Container(width: 1, height: 30, color: AppColors.divider),
                _buildSubStat('Pending', formatRs(_totalPending), AppColors.error),
                Container(width: 1, height: 30, color: AppColors.divider),
                _buildSubStat('Commission', formatRs(_totalCommission), AppColors.warning),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Net Profit Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Profit',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRs(_netProfit),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(_totalCommission / _totalRevenue * 100).toStringAsFixed(0)}% rate',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.yellow.shade300,
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

  Widget _buildSubStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing(double percentage, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 6,
              backgroundColor: const Color(0xFFEDE8DF),
              color: AppColors.primary,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['summary', 'classes', 'teachers'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)]
                      : null,
                ),
                child: Text(
                  tab[0].toUpperCase() + tab.substring(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key Metrics Grid
        Text(
          'KEY METRICS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            _buildMetricCard('Last Month Revenue', _totalRevenue, '${(_totalRevenue / 1000).toStringAsFixed(0)}K', AppColors.primary),
            _buildMetricCard('Total Commission', _totalCommission, '${(_totalCommission / _totalRevenue * 100).toStringAsFixed(1)}%', AppColors.warning),
            _buildMetricCard('Total Receivable', _totalReceivable, '${(_totalReceivable / 1000).toStringAsFixed(0)}K', AppColors.info),
            _buildMetricCard('Total Received', _totalReceived, '${_receivedPercentage.toStringAsFixed(1)}%', AppColors.success),
            _buildMetricCard('Total Pending', _totalPending, '${(100 - _receivedPercentage).toStringAsFixed(1)}%', AppColors.error),
            _buildMetricCard('Net Profit', _netProfit, 'After comm.', AppColors.info),
          ],
        ),
        const SizedBox(height: 20),

        // Student Payment Summary
        Text(
          'STUDENT PAYMENT SUMMARY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E0D8)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStudentStat('Total Students', _totalStudents, AppColors.textPrimary, const Color(0xFFF3F4F6)),
                  _buildStudentStat('Paid', _totalPaidStudents, AppColors.success, const Color(0xFFDCFCE7)),
                  _buildStudentStat('Not Paid', _totalNotPaidStudents, Colors.red.shade700, const Color(0xFFFEE2E2)),
                ],
              ),
              const SizedBox(height: 16),
              _buildProgressBar(_paymentPercentage),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_paymentPercentage.toStringAsFixed(1)}% paid',
                    style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${(100 - _paymentPercentage).toStringAsFixed(1)}% pending',
                    style: TextStyle(fontSize: 12, color: Colors.orange.shade700, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, int value, String badge, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: accent, width: 3),
          top: const BorderSide(color: AppColors.border),
          right: const BorderSide(color: AppColors.border),
          bottom: const BorderSide(color: AppColors.border),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRs(value),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildStudentStat(String label, int value, Color color, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Column(
      children: [
        Container(
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.transparent,
              color: AppColors.success,
              minHeight: 7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassesTab() {
    final displayClasses = _showAllClasses ? _classesData : _classesData.take(3).toList();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CLASSES FINANCIAL OVERVIEW',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _showAllClasses = !_showAllClasses),
              child: Text(
                _showAllClasses ? 'Show Less' : 'View All',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayClasses.asMap().entries.map((entry) => _buildClassCard(entry.value, entry.key * 70)),
      ],
    );
  }

  Widget _buildClassCard(Map<String, dynamic> cls, int delay) {
    final paidPercentage = (cls['paidS'] as int) / (cls['total'] as int) * 100;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cls['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${cls['teacher']} · ${cls['grade']}',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: cls['teacherPaid'] ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cls['teacherPaid'] ? AppColors.success.withOpacity(0.3) : AppColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cls['teacherPaid'] ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 12,
                      color: cls['teacherPaid'] ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cls['teacherPaid'] ? 'Teacher Paid' : 'Unpaid',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cls['teacherPaid'] ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          
          // Financial Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: [
              _buildClassMetric('Total Revenue', formatRs(cls['revenue']), AppColors.primary),
              _buildClassMetric('Commission', formatRs(cls['commission']), AppColors.warning),
              _buildClassMetric('Received', formatRs(cls['received']), AppColors.success),
              _buildClassMetric('Pending', formatRs(cls['pending']), cls['pending'] > 0 ? AppColors.error : AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          
          // Student Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('${cls['paidS']} Paid', AppColors.success, AppColors.success.withOpacity(0.1)),
              if (cls['unpaidS'] > 0)
                _buildChip('${cls['unpaidS']} Unpaid', AppColors.warning, AppColors.warning.withOpacity(0.1)),
              _buildChip('${cls['total']} Students', AppColors.textSecondary, AppColors.divider),
            ],
          ),
          const SizedBox(height: 8),
          _buildProgressBar(paidPercentage),
          const SizedBox(height: 5),
          Text(
            '${paidPercentage.toStringAsFixed(0)}% collected',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildClassMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersTab() {
    return Column(
      children: [
        Text(
          'TEACHER PAYMENT STATUS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        
        // Teacher Stats Cards
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E0D8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        '$_paidTeachers',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                      Text('Paid', style: TextStyle(fontSize: 12, color: AppColors.success.withOpacity(0.8))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        '$_unpaidTeachers',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      Text('Unpaid', style: TextStyle(fontSize: 12, color: Colors.orange.shade700.withOpacity(0.8))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Process Payments Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C3D2E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text(
              'Process Payments',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        Text(
          'BY CLASS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        
        ..._classesData.asMap().entries.map((entry) => _buildTeacherClassItem(entry.value, entry.key * 60)),
      ],
    );
  }

  Widget _buildTeacherClassItem(Map<String, dynamic> cls, int delay) {
    final initials = cls['teacher'].split(' ').map((s) => s[0]).join('').substring(0, 2);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E0D8)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cls['teacherPaid'] ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cls['teacherPaid'] ? const Color(0xFF15803D) : const Color(0xFFB45309),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cls['teacher'],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cls['name']} · ${cls['grade']}',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRs(cls['commission']),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C3D2E)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cls['teacherPaid'] ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cls['teacherPaid'] ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Text(
                  cls['teacherPaid'] ? 'Paid' : 'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cls['teacherPaid'] ? const Color(0xFF15803D) : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}