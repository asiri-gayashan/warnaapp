import 'package:flutter/material.dart';
import 'package:warna_app/features/institute/ui/screens/tutor_detail_page.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/new/user_list_card.dart';
import '../../../../shared/widgets/new/info_badge.dart';
import '../../../../shared/widgets/new/empty_list_state.dart';

class InstituteTutorsPage extends StatefulWidget {
  const InstituteTutorsPage({Key? key}) : super(key: key);

  @override
  State<InstituteTutorsPage> createState() => _InstituteTutorsPageState();
}

class _InstituteTutorsPageState extends State<InstituteTutorsPage> {
  // Sample tutors data
  final List<Map<String, dynamic>> _allTutors = [
    {
      'id': 'T001',
      'name': 'Dr. John Smith',
      'subject': 'Mathematics',
      'qualification': 'Ph.D. in Mathematics',
      'experience': '8 years',
      'rating': 4.8,
      'studentsCount': 45,
      'email': 'john.smith@example.com',
      'phone': '+94 77 123 4567',
      'status': 'Active',
    },
    {
      'id': 'T002',
      'name': 'Prof. Sarah Johnson',
      'subject': 'Physics',
      'qualification': 'M.Sc. in Physics',
      'experience': '12 years',
      'rating': 4.9,
      'studentsCount': 52,
      'email': 'sarah.j@example.com',
      'phone': '+94 77 234 5678',
      'status': 'Active',
    },
    {
      'id': 'T003',
      'name': 'Dr. Michael Chen',
      'subject': 'Chemistry',
      'qualification': 'Ph.D. in Chemistry',
      'experience': '6 years',
      'rating': 4.7,
      'studentsCount': 38,
      'email': 'michael.c@example.com',
      'phone': '+94 77 345 6789',
      'status': 'Active',
    },
    {
      'id': 'T004',
      'name': 'Prof. Emily Williams',
      'subject': 'English',
      'qualification': 'M.A. in English Literature',
      'experience': '10 years',
      'rating': 4.9,
      'studentsCount': 41,
      'email': 'emily.w@example.com',
      'phone': '+94 77 456 7890',
      'status': 'Active',
    },
    {
      'id': 'T005',
      'name': 'Dr. David Brown',
      'subject': 'Computer Science',
      'qualification': 'Ph.D. in Computer Science',
      'experience': '7 years',
      'rating': 4.8,
      'studentsCount': 33,
      'email': 'david.b@example.com',
      'phone': '+94 77 567 8901',
      'status': 'On Leave',
    },
    {
      'id': 'T006',
      'name': 'Prof. Lisa Davis',
      'subject': 'Biology',
      'qualification': 'M.Sc. in Biology',
      'experience': '9 years',
      'rating': 4.6,
      'studentsCount': 29,
      'email': 'lisa.d@example.com',
      'phone': '+94 77 678 9012',
      'status': 'Active',
    },
    {
      'id': 'T007',
      'name': 'Dr. Robert Wilson',
      'subject': 'Mathematics',
      'qualification': 'Ph.D. in Applied Mathematics',
      'experience': '11 years',
      'rating': 4.9,
      'studentsCount': 47,
      'email': 'robert.w@example.com',
      'phone': '+94 77 789 0123',
      'status': 'Active',
    },
    {
      'id': 'T008',
      'name': 'Prof. Jennifer Lee',
      'subject': 'Physics',
      'qualification': 'M.Sc. in Physics',
      'experience': '8 years',
      'rating': 4.7,
      'studentsCount': 35,
      'email': 'jennifer.l@example.com',
      'phone': '+94 77 890 1234',
      'status': 'Active',
    },
    {
      'id': 'T009',
      'name': 'Dr. James Taylor',
      'subject': 'Chemistry',
      'qualification': 'Ph.D. in Chemistry',
      'experience': '5 years',
      'rating': 4.5,
      'studentsCount': 26,
      'email': 'james.t@example.com',
      'phone': '+94 77 901 2345',
      'status': 'Active',
    },
    {
      'id': 'T010',
      'name': 'Prof. Maria Garcia',
      'subject': 'English',
      'qualification': 'M.A. in Linguistics',
      'experience': '7 years',
      'rating': 4.8,
      'studentsCount': 31,
      'email': 'maria.g@example.com',
      'phone': '+94 77 012 3456',
      'status': 'Inactive',
    },
    {
      'id': 'T011',
      'name': 'Dr. Thomas Anderson',
      'subject': 'Computer Science',
      'qualification': 'Ph.D. in AI',
      'experience': '6 years',
      'rating': 4.9,
      'studentsCount': 28,
      'email': 'thomas.a@example.com',
      'phone': '+94 77 123 4567',
      'status': 'Active',
    },
    {
      'id': 'T012',
      'name': 'Prof. Patricia White',
      'subject': 'Biology',
      'qualification': 'M.Sc. in Biotechnology',
      'experience': '8 years',
      'rating': 4.7,
      'studentsCount': 34,
      'email': 'patricia.w@example.com',
      'phone': '+94 77 234 5678',
      'status': 'Active',
    },
  ];

  void _onTutorTap(Map<String, dynamic> tutor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TutorDetailPage(tutor: tutor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Tutors',
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
          // Tutors List
          Expanded(
            child: _allTutors.isEmpty
                ? const EmptyListState(
                    icon: Icons.person_outline,
                    title: 'No tutors found',
                    subtitle: 'No tutors assigned yet',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _allTutors.length,
                    itemBuilder: (context, index) {
                      final tutor = _allTutors[index];
                      return UserListCard(
                        name: tutor['name'],
                        title: tutor['subject'],
                        titleColor: AppColors.primary,
                        subtitle: "0768645011 • Kururnegala",
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () => _onTutorTap(tutor),
                        badges: [
                          InfoBadge(
                            icon: Icons.video_call,
                            text: '3 Classes',
                            color: AppColors.info,
                          ),
                          InfoBadge(
                            icon: Icons.people_outline,
                            text: '${tutor['studentsCount']} students',
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
