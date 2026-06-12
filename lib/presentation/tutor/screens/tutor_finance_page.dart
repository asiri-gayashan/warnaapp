import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_finance_controller.dart';
import 'package:warna_app/shared/widgets/new/info_badge.dart';

class TutorFinancePage extends StatefulWidget {
  const TutorFinancePage({Key? key}) : super(key: key);

  @override
  State<TutorFinancePage> createState() => _TutorFinancePageState();
}

class _TutorFinancePageState extends State<TutorFinancePage> {
  late TutorFinanceController _controller;
  bool _showAllClasses = false;

  @override
  void initState() {
    super.initState();
    _controller = TutorFinanceController();
    _controller.fetchAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Formatted month label ─────────────────────────────────
  String get _formattedMonth {
    const months = [
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
    final m = _controller.selectedMonth;
    return '${months[m.month - 1]} ${m.year}';
  }

  String _rs(double v) => 'Rs ${v.toStringAsFixed(0)}';

  // ── Month picker ──────────────────────────────────────────
  Future<void> _pickMonth() async {
    DateTime temp = _controller.selectedMonth;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Select Month & Year',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Year row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => setD(
                        () => temp = DateTime(temp.year - 1, temp.month),
                      ),
                    ),
                    Text(
                      '${temp.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => setD(
                        () => temp = DateTime(temp.year + 1, temp.month),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Month grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 12,
                  itemBuilder: (_, i) {
                    const names = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
                    ];
                    final isSel = temp.month == i + 1;
                    return GestureDetector(
                      onTap: () =>
                          setD(() => temp = DateTime(temp.year, i + 1)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          names[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSel
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _controller.setMonth(temp);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
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
          ),
          body: _controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(),
                      const SizedBox(height: 20),
                      _buildClassesSection(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ── Hero card ─────────────────────────────────────────────

  Widget _buildHeroCard() {
    final s = _controller.summary;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Gradient top ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT: KPI
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Earnings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _rs(s.myEarnings),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // RIGHT: Month chip
                GestureDetector(
                  onTap: _pickMonth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formattedMonth,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Sub-stats row ─────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                _subStat('Total Revenue', _rs(s.totalRevenue)),
                _vDivider(),
                _subStat('Received', _rs(s.totalReceived)),
                _vDivider(),
                _subStat('Pending', _rs(s.totalPending)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3));

  // ── Classes section ───────────────────────────────────────

  Widget _buildClassesSection() {
    final display = _showAllClasses
        ? _controller.classes
        : _controller.classes.take(3).toList();

    if (_controller.classes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No classes found for this month',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

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
        ...display.map((cls) => _buildClassCard(cls)),
      ],
    );
  }

  Widget _buildClassCard(TutorClassFinanceModel cls) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            cls.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Grade ${cls.grade}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Financial metrics
          Row(
            children: [
              Expanded(child: _metricTile('Received', _rs(cls.received))),
              Expanded(child: _metricTile('Pending', _rs(cls.pending))),
            ],
          ),

          const SizedBox(height: 14),

          // Institute commission breakdown
          _buildCommissionBreakdown(cls),

          const SizedBox(height: 14),

          // Student badges
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              InfoBadge(
                icon: Icons.people_outline,
                text: '${cls.totalCount} Students',
                color: AppColors.primary,
              ),
              InfoBadge(
                icon: Icons.check_circle_outline,
                text: '${cls.paidCount} Paid',
                color: AppColors.success,
              ),
              if (cls.unpaidCount > 0)
                InfoBadge(
                  icon: Icons.warning_amber_rounded,
                  text: '${cls.unpaidCount} Unpaid',
                  color: AppColors.warning,
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: cls.totalCount > 0 ? cls.paidCount / cls.totalCount : 0,
              minHeight: 7,
              backgroundColor: AppColors.divider,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cls.totalCount > 0
                ? '${((cls.paidCount / cls.totalCount) * 100).toStringAsFixed(0)}% collected'
                : '0% collected',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Institute commission breakdown ─────────────────────────

  Widget _buildCommissionBreakdown(TutorClassFinanceModel cls) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: _breakdownStat(
              'Revenue',
              _rs(cls.revenue),
              AppColors.textPrimary,
            ),
          ),
          _opSymbol('−'),
          Expanded(
            child: _breakdownStat(
              'Institute Cut',
              _rs(cls.instituteCommission),
              AppColors.warning,
            ),
          ),
          _opSymbol('='),
          Expanded(
            child: _breakdownStat(
              'My Share',
              _rs(cls.myShare),
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _opSymbol(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        symbol,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _metricTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
