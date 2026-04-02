import 'package:flutter/material.dart';
import 'package:warna_app/features/institute/ui/screens/mark_attendance_page.dart';
import 'package:warna_app/features/institute/ui/screens/mark_payment_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/new/stat_column.dart';
import '../../../../shared/widgets/new/info_tile.dart';
import '../../../../shared/widgets/new/upcoming_class_list_tile.dart';

class StudentDetailPage extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentDetailPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Student Details',
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
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      student['name'][0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    student['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'example@gmail.com',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatColumn(label: 'Grade', value: student['grade']),
                  StatColumn(label: 'Age', value: '15'),
                  StatColumn(label: 'Classes', value: '${student['sessions']}'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: student['email'],
            ),
            InfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: student['phone'],
            ),

            const SizedBox(height: 24),

            // Personal Information
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InfoTile(
              icon: Icons.location_on_outlined,
              label: 'District',
              value: 'Colombo',
            ),
            InfoTile(icon: Icons.route, label: 'Postal Code', value: '00000'),
            InfoTile(
              icon: Icons.home_outlined,
              label: 'Address',
              value: 'Colombo, Sri Lanka',
            ),

            const SizedBox(height: 24),

            const Text(
              'Enrolled Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

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
                  // 5 Upcoming Classes (Limited)
                  UpcomingClassListTile(
                    className: 'Advanced Mathematics',
                    grade: 'Grade 10',
                    time: '9:00 AM - 10:30 AM',
                    teacher: 'Mr. Kumar',
                    room: 'Room 101',
                    iconColor: AppColors.secondary,
                  ),
                  UpcomingClassListTile(
                    className: 'Physics Fundamentals',
                    grade: 'Grade 11',
                    time: '10:45 AM - 12:15 PM',
                    teacher: 'Ms. Sharma',
                    room: 'Lab 3',
                    iconColor: AppColors.secondary,
                  ),
                  UpcomingClassListTile(
                    className: 'English Literature',
                    grade: 'Grade 9',
                    time: '1:00 PM - 2:30 PM',
                    teacher: 'Mrs. Singh',
                    room: 'Room 205',
                    iconColor: AppColors.secondary,
                  ),
                  UpcomingClassListTile(
                    className: 'Chemistry Lab',
                    grade: 'Grade 10',
                    time: '2:45 PM - 4:15 PM',
                    teacher: 'Dr. Verma',
                    room: 'Lab 1',
                    iconColor: AppColors.secondary,
                  ),
                  UpcomingClassListTile(
                    className: 'Computer Science',
                    grade: 'Grade 11',
                    time: '4:30 PM - 6:00 PM',
                    teacher: 'Mr. Patil',
                    room: 'Computer Lab',
                    iconColor: AppColors.secondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarkAttendancePage(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.assignment_add),
                    label: const Text('Mark Attendance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarkPaymentPage(),
                        ),
                      );
                    },

                    icon: const Icon(Icons.payment),
                    label: const Text('Mark Payments'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
