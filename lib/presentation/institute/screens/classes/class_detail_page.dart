import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/models/class_model.dart';
import 'package:warna_app/features/institute/ui/screens/fees_attendance_page.dart';
import 'package:warna_app/features/tutor/ui/screens/enroll_student_page.dart';
import 'package:warna_app/presentation/institute/screens/classes/institute_edit_class.dart';
import 'package:warna_app/shared/widgets/new/class_header_card.dart';
import 'package:warna_app/shared/widgets/new/schedule_info_card.dart';
import 'package:warna_app/shared/widgets/new/student_payment_overview_card.dart';

class ClassDetailPage extends StatelessWidget {
  // Using dummy data instead of required parameter
  final ClassModel ClassItemDetails;

  ClassDetailPage({Key? key, required this.ClassItemDetails})
    : super(key: key) {
    print(ClassItemDetails.name);
  }

  String TutorName = "Tutor Name";
  bool isReceived = false;

  // Dummy class data
  final classItem = (
    id: '1',
    name: 'Mathematics Advanced',
    subject: 'Mathematics',
    grade: 'Grade 10',
    teacher: 'Anura Dharmasiri',
    day: 'Monday',
    time: '09:00 AM',
    duration: '2 hours',
    totalStudents: 30,
    description:
        'Advanced mathematics class focusing on algebra and geometry. Students will learn fundamental concepts and problem-solving techniques.',
  );

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
          'Class Details Institute',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book,
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
                              ClassItemDetails.name.length > 21
                                  ? ClassItemDetails.name.substring(0, 22) + ''
                                  : ClassItemDetails.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${ClassItemDetails.subjectName} • ${ClassItemDetails.tutorName}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.sailing,
                        label:
                            SelectOptions.newgradesList.firstWhere(
                              (e) =>
                                  e['id'] == ClassItemDetails.grade.toString(),
                            )['name'] ??
                            '',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.people,
                        label: '${ClassItemDetails.studentCount} Students',
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const InstituteEditClassPage(),
                            ),
                          ),
                        },
                        child: _buildInfoChip(icon: Icons.edit, label: 'Edit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Schedule Information
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ScheduleInfoCard(
              day:
                  SelectOptions.days.firstWhere(
                    (e) => e['id'] == ClassItemDetails.day.toString(),
                  )['name'] ??
                  '',
              time: ClassItemDetails.startTime.length >= 5
                  ? ClassItemDetails.startTime.substring(0, 5)
                  : ClassItemDetails
                        .startTime, // Assuming startTime is in "HH:mm:ss" format
              duration: ClassItemDetails.duration,
            ),

            const SizedBox(height: 24),

            // Student Payment Status Card
            const StudentPaymentOverviewCard(
              paidStudents: 10,
              nonPaidStudents: 20,
            ),

            const SizedBox(height: 16),

            // Institute Payment Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ClassItemDetails.tutorName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tutor Payment Status',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isReceived
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isReceived ? Icons.check_circle : Icons.pending,
                          color: isReceived ? Colors.green : Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isReceived ? 'Paid' : 'Pending',
                          style: TextStyle(
                            color: isReceived ? Colors.green : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                ClassItemDetails.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 12),

            // Fees & Attendance and Enroll Student Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeesAttendancePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Fees & Attendance'),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnrollStudentPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    color: AppColors.textPrimary,
                    iconSize: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Remove Class Button
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // void _showRemoveClassDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Remove Class'),
  //         content: const Text(
  //           'Are you sure you want to remove this class? This action cannot be undone.',
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text('Class removed successfully'),
  //                   backgroundColor: Colors.red,
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const Text('Remove'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
