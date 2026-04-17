import 'package:flutter/material.dart';
import 'package:warna_app/presentation/institute/screens/student/student_detail_page.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/shared/widgets/new/user_list_card.dart';
import 'package:warna_app/shared/widgets/new/info_badge.dart';
import 'package:warna_app/shared/widgets/new/empty_list_state.dart';

class InstituteStudentsPage extends StatefulWidget {
  const InstituteStudentsPage({Key? key}) : super(key: key);

  @override
  State<InstituteStudentsPage> createState() => _InstituteStudentsPageState();
}

class _InstituteStudentsPageState extends State<InstituteStudentsPage> {
  // Sample students data
  final List<Map<String, dynamic>> _allStudents = [
    {
      'id': 'S001',
      'name': 'Emma Watson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 92,
      'sessions': 1,
      'email': 'emma.w@example.com',
      'phone': '+94 77 123 4567',
    },
    {
      'id': 'S002',
      'name': 'James Smith',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 78,
      'sessions': 1,
      'email': 'james.s@example.com',
      'phone': '+94 77 234 5678',
    },
    {
      'id': 'S003',
      'name': 'Michael Brown',
      'subject': 'Chemistry',
      'grade': 'Grade 10',
      'attendance': 88,
      'sessions': 2,
      'email': 'michael.b@example.com',
      'phone': '+94 77 345 6789',
    },
    {
      'id': 'S004',
      'name': 'Sarah Johnson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 95,
      'sessions': 2,
      'email': 'sarah.j@example.com',
      'phone': '+94 77 456 7890',
    },
    {
      'id': 'S005',
      'name': 'David Wilson',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 82,
      'sessions': 2,
      'email': 'david.w@example.com',
      'phone': '+94 77 567 8901',
    },
    {
      'id': 'S006',
      'name': 'Emily Davis',
      'subject': 'English',
      'grade': 'Grade 9',
      'attendance': 96,
      'sessions': 2,
      'email': 'emily.d@example.com',
      'phone': '+94 77 678 9012',
    },
    {
      'id': 'S007',
      'name': 'Daniel Martinez',
      'subject': 'Computer Science',
      'grade': 'Grade 11',
      'attendance': 89,
      'sessions': 2,
      'email': 'daniel.m@example.com',
      'phone': '+94 77 789 0123',
    },
    {
      'id': 'S008',
      'name': 'Lisa Anderson',
      'subject': 'Mathematics',
      'grade': 'Grade 10',
      'attendance': 91,
      'sessions': 2,
      'email': 'lisa.a@example.com',
      'phone': '+94 77 890 1234',
    },
    {
      'id': 'S009',
      'name': 'Robert Taylor',
      'subject': 'Chemistry',
      'grade': 'Grade 10',
      'attendance': 84,
      'sessions': 2,
      'email': 'robert.t@example.com',
      'phone': '+94 77 901 2345',
    },
    {
      'id': 'S010',
      'name': 'Jennifer Thomas',
      'subject': 'Biology',
      'grade': 'Grade 9',
      'attendance': 93,
      'sessions': 2,
      'email': 'jennifer.t@example.com',
      'phone': '+94 77 012 3456',
    },
    {
      'id': 'S011',
      'name': 'William Jackson',
      'subject': 'Physics',
      'grade': 'Grade 11',
      'attendance': 79,
      'sessions': 3,
      'email': 'william.j@example.com',
      'phone': '+94 77 123 4567',
    },
    {
      'id': 'S012',
      'name': 'Mary White',
      'subject': 'English',
      'grade': 'Grade 9',
      'attendance': 97,
      'sessions': 2,
      'email': 'mary.w@example.com',
      'phone': '+94 77 234 5678',
    },
  ];

  void _onStudentTap(Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailPage(student: student),
      ),
    );

    // print("Hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Students',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search and Filter Section

          // Results Count

          // Students List
          Expanded(
            child: _allStudents.isEmpty
                ? const EmptyListState(
                    icon: Icons.people_outline,
                    title: 'No students found',
                    subtitle: 'No students assigned yet',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _allStudents.length,
                    itemBuilder: (context, index) {
                      final student = _allStudents[index];
                      return UserListCard(
                        name: student['name'],
                        title: '${student['subject']} • ${student['grade']}',
                        trailingIcon: Icons.remove_red_eye_outlined,
                        onTap: () => _onStudentTap(student),
                        badges: [
                          InfoBadge(
                            icon: Icons.call,
                            text: '0768645011',
                            color: AppColors.success,
                          ),
                          InfoBadge(
                            icon: Icons.video_call,
                            text: '${student['sessions']} Classes',
                            color: AppColors.primary,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
