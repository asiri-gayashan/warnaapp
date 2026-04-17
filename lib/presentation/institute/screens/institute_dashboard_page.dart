import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/features/auth/logic/auth_service.dart';
import 'package:warna_app/shared/widgets/new/metric_overview_card.dart';
import 'package:warna_app/shared/widgets/new/performance_row_item.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';
import 'package:warna_app/shared/widgets/new/category_grid_card.dart';
import 'package:warna_app/shared/widgets/new/quick_stat_row_item.dart';

class InstituteDashboardPage extends StatelessWidget {
  const InstituteDashboardPage({Key? key}) : super(key: key);


  

  // todo: add below logout for the code with remove token from the backend also.

//   Future<void> logout() async {
//   try {
//     final refreshToken = await TokenService.getRefreshToken();
//     await Dio().post('https://yourapi.com/auth/logout', data: {
//       'refreshToken': refreshToken,
//     });
//   } catch (_) {
//     // continue even if server call fails
//   } finally {
//     await TokenService.clearTokens(); // clears secure storage
//     await UserService.clearUser();    // clears shared preferences

//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () => AuthService.logoutUser(context: context),
          ),
        ],
        title: const Text(
          'Institute Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Institute Overview Section
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
                    'Institute Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'March 2024',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Key Metrics Grid
                  Row(
                    children: [
                      Expanded(
                        child: MetricOverviewCard(
                          label: 'Total Students',
                          value: '245',
                          icon: Icons.people_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricOverviewCard(
                          label: 'Total Teachers',
                          value: '18',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricOverviewCard(
                          label: 'Total Classes',
                          value: '32',
                          icon: Icons.class_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Financial Metrics
                  Row(
                    children: [
                      Expanded(
                        child: MetricOverviewCard(
                          label: 'Monthly Revenue',
                          value: 'Rs 285,000',
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricOverviewCard(
                          label: 'Total Commission',
                          value: 'Rs 42,750',
                          icon: Icons.percent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Class Performance Section
            const Text(
              'Class Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Top Performing Classes
            Container(
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
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: AppColors.success,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Top Performing Classes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PerformanceRowItem(
                    className: 'Advanced Mathematics - Grade 10',
                    value: '92%',
                    metric: 'Attendance',
                    color: AppColors.success,
                  ),
                  PerformanceRowItem(
                    className: 'Physics Fundamentals - Grade 11',
                    value: '88%',
                    metric: 'Attendance',
                    color: AppColors.success,
                  ),
                  PerformanceRowItem(
                    className: 'English Literature - Grade 9',
                    value: '85%',
                    metric: 'Attendance',
                    color: AppColors.success,
                  ),
                ],
              ),
            ),

            // Least Performing Classes
            Container(
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
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.trending_down,
                          color: Colors.orange,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Needs Improvement',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PerformanceRowItem(
                    className: 'Chemistry Lab - Grade 10',
                    value: '67%',
                    metric: 'Attendance',
                    color: Colors.orange,
                  ),
                  PerformanceRowItem(
                    className: 'Computer Science - Grade 11',
                    value: '71%',
                    metric: 'Attendance',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Upcoming Classes Section ──────────────────────────────────
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
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5 Upcoming Classes (Limited)
                  UpcomingClassListTile(
                    className: 'Advanced Mathematics',
                    grade: 'Grade 10',
                    time: '9:00 AM - 10:30 AM',
                    teacher: 'Mr. Kumar',
                    room: 'Room 101',
                  ),
                  UpcomingClassListTile(
                    className: 'Physics Fundamentals',
                    grade: 'Grade 11',
                    time: '10:45 AM - 12:15 PM',
                    teacher: 'Ms. Sharma',
                    room: 'Lab 3',
                  ),
                  UpcomingClassListTile(
                    className: 'English Literature',
                    grade: 'Grade 9',
                    time: '1:00 PM - 2:30 PM',
                    teacher: 'Mrs. Singh',
                    room: 'Room 205',
                  ),
                  UpcomingClassListTile(
                    className: 'Chemistry Lab',
                    grade: 'Grade 10',
                    time: '2:45 PM - 4:15 PM',
                    teacher: 'Dr. Verma',
                    room: 'Lab 1',
                  ),
                  UpcomingClassListTile(
                    className: 'Computer Science',
                    grade: 'Grade 11',
                    time: '4:30 PM - 6:00 PM',
                    teacher: 'Mr. Patil',
                    room: 'Computer Lab',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Report Categories Section
            const Text(
              'Generate Reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Report Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                CategoryGridCard(
                  title: 'Class Reports',
                  subtitle: 'Class-wise performance',
                  icon: Icons.class_,
                  color: Colors.orange,
                  onTap: () {},
                ),
                CategoryGridCard(
                  title: 'Student Reports',
                  subtitle: 'Individual student data',
                  icon: Icons.people,
                  color: AppColors.info,
                  onTap: () {},
                ),
                CategoryGridCard(
                  title: 'Teacher Reports',
                  subtitle: 'Teacher performance',
                  icon: Icons.person,
                  color: Colors.purple,
                  onTap: () {},
                ),
                CategoryGridCard(
                  title: 'Teacher Payment Reports',
                  subtitle: 'Salary & commission',
                  icon: Icons.account_balance_wallet,
                  color: Colors.teal,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Stats Section
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  QuickStatRowItem(
                    label: 'Total Students Enrolled',
                    value: '245',
                    change: '+12 this month',
                  ),
                  QuickStatRowItem(
                    label: 'Active Teachers',
                    value: '18',
                    change: '2 on leave',
                  ),
                  QuickStatRowItem(
                    label: 'Total Classes',
                    value: '32',
                    change: '24 active',
                  ),
                  QuickStatRowItem(
                    label: 'Monthly Revenue',
                    value: 'Rs 285,000',
                    change: '+15.3%',
                  ),
                  QuickStatRowItem(
                    label: 'Commission Paid',
                    value: 'Rs 42,750',
                    change: '15% of revenue',
                  ),
                  QuickStatRowItem(
                    label: 'Pending Payments',
                    value: 'Rs 38,500',
                    change: '8 teachers',
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
