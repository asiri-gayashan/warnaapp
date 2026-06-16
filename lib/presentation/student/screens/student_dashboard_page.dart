import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/student/controllers/student_dashboard_controller.dart';
import 'package:warna_app/presentation/student/screens/notifications_page.dart';
import 'package:warna_app/presentation/student/screens/student_profile_page.dart';
import 'package:warna_app/shared/widgets/new/metric_overview_card.dart';
import 'package:warna_app/shared/widgets/new/performance_row_item.dart';
import 'package:warna_app/shared/widgets/new/quick_stat_row_item.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

// ============================================================
// MAIN DASHBOARD PAGE
// ============================================================

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  late StudentDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StudentDashboardController();
    _controller.fetchAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final s = _controller.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentProfilePage()),
              );
            },
          ),
        ],
        title: const Text(
          'Student Dashboard',
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Overview ────────────────────────────────
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
                          'My Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Total Classes',
                                value: '${s.totalClasses}',
                                icon: Icons.class_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Attendance',
                                value: '${s.attendancePercentage.toStringAsFixed(0)}%',
                                icon: Icons.event_available_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Institutes',
                                value: '${s.institutesCount}',
                                icon: Icons.apartment,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Paid This Month',
                                value: 'Rs ${s.paidThisMonth.toStringAsFixed(0)}',
                                icon: Icons.payments_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Pending Payments',
                                value: 'Rs ${s.pendingPayments.toStringAsFixed(0)}',
                                icon: Icons.pending_actions_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Best Attendance ──────────────────────────
                  _PerformanceCard(
                    title: 'Best Attendance',
                    icon: Icons.star,
                    iconColor: AppColors.success,
                    items: _controller.topClasses,
                    metricColor: AppColors.success,
                  ),

                  const SizedBox(height: 12),

                  // ── Needs Attention ──────────────────────────
                  _PerformanceCard(
                    title: 'Needs Attention',
                    icon: Icons.trending_down,
                    iconColor: Colors.orange,
                    items: _controller.leastClasses,
                    metricColor: Colors.orange,
                  ),

                  const SizedBox(height: 16),

                  // ── Upcoming Classes ────────────────────────
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Upcoming Classes',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_controller.upcomingClasses.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No upcoming classes',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          ..._controller.upcomingClasses.map(
                            (cls) => UpcomingClassListTile(
                              className: cls.name,
                              grade: 'Grade ${cls.grade}',
                              time: '${cls.startTime} - ${cls.endTime}',
                              teacher: cls.tutorName,
                              day: cls.dayName,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick Statistics ────────────────────────
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
                          'Quick Statistics',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        QuickStatRowItem(
                          label: 'Total Classes',
                          value: '${s.totalClasses}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Overall Attendance',
                          value: '${s.attendancePercentage.toStringAsFixed(0)}%',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Paid This Month',
                          value: 'Rs ${s.paidThisMonth.toStringAsFixed(0)}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Tutors',
                          value: '${s.tutorsCount}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Institutes',
                          value: '${s.institutesCount}',
                          change: '',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ============================================================
// PERFORMANCE CARD WIDGET
// ============================================================

class _PerformanceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<StudentClassPerformanceModel> items;
  final Color metricColor;

  const _PerformanceCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.metricColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Text(
              'No data available',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            ...items.map(
              (c) => PerformanceRowItem(
                className: '${c.name} - Grade ${c.grade}',
                value: '${c.attendancePercentage}%',
                metric: 'Attendance',
                color: metricColor,
              ),
            ),
        ],
      ),
    );
  }
}
