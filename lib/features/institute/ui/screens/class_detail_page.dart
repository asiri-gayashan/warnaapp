import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/new/class_header_card.dart';
import '../../../../shared/widgets/new/schedule_info_card.dart';
import '../../../../shared/widgets/new/student_payment_overview_card.dart';
import '../../../../shared/widgets/new/institute_payment_status_card.dart';
import '../../../../shared/widgets/new/class_action_buttons.dart';

class ClassDetailPage extends StatelessWidget {
  // Using dummy data instead of required parameter
  ClassDetailPage({Key? key}) : super(key: key);

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
            ClassHeaderCard(
              name: classItem.name,
              subject: classItem.subject,
              teacher: classItem.teacher,
              grade: classItem.grade,
              totalStudents: classItem.totalStudents,
            ),

            const SizedBox(height: 24),

            // Schedule Information
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ScheduleInfoCard(
              day: classItem.day,
              time: classItem.time,
              duration: classItem.duration,
            ),

            const SizedBox(height: 24),

            // Student Payment Status Card
            const StudentPaymentOverviewCard(
              paidStudents: 10,
              nonPaidStudents: 20,
            ),

            const SizedBox(height: 16),

            // Institute Payment Status
            const InstitutePaymentStatusCard(
              instituteName: 'Susipwin Kurunegala',
              isReceived: true,
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              classItem.description,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons Section
            const Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Fees & Attendance and Enroll Student Row
            const ClassActionButtons(),

            const SizedBox(height: 30),

            // Remove Class Button
          ],
        ),
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
