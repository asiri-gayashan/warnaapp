import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:warna_app/presentation/institute/screens/classes/enroll_student_page.dart';
import 'package:warna_app/presentation/institute/screens/classes/fees_attendance_page.dart';

class ClassActionButtons extends StatelessWidget {
  const ClassActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
