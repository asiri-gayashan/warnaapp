import 'package:flutter/material.dart';
import 'package:warna_app/features/institute/ui/screens/tutor_detail_page.dart';
import '../../../../../core/constants/app_colors.dart';

class InstituteTutorsPage extends StatefulWidget {
  const InstituteTutorsPage({Key? key}) : super(key: key);

  @override
  State<InstituteTutorsPage> createState() => _InstituteTutorsPageState();
}

class _InstituteTutorsPageState extends State<InstituteTutorsPage> {
  String? _selectedSubject;

  // Sample subjects for filter
  final List<String> _subjects = [
    'All Subjects',
    'Mathematics',
    'Physics',
    'Chemistry',
    'English',
    'Computer Science',
    'Biology',
  ];

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

  List<Map<String, dynamic>> get _filteredTutors {
    if (_selectedSubject == null || _selectedSubject == 'All Subjects') {
      return _allTutors;
    }
    return _allTutors.where((tutor) {
      return tutor['subject'] == _selectedSubject;
    }).toList();
  }

  void _onTutorTap(Map<String, dynamic> tutor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorDetailPage(tutor: tutor),
      ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primary),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chip (if subject is selected)
          if (_selectedSubject != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Chip(
                    label: Text(_selectedSubject!),
                    onDeleted: () {
                      setState(() {
                        _selectedSubject = null;
                      });
                    },
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    deleteIconColor: AppColors.primary,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

          // Results Count
          Padding(
            padding: EdgeInsets.fromLTRB(16, _selectedSubject != null ? 0 : 16, 16, 8),
            child: Row(
              children: [
                Text(
                  '${_filteredTutors.length} tutors found',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Tutors List
          Expanded(
            child: _filteredTutors.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredTutors.length,
              itemBuilder: (context, index) {
                final tutor = _filteredTutors[index];
                return _buildTutorCard(tutor, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorCard(Map<String, dynamic> tutor, int index) {
    // Status color

    return GestureDetector(
      onTap: () => _onTutorTap(tutor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar with tutor initial
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                tutor['name'][0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Tutor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tutor['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tutor['subject'],
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                   "0768645011 • Kururnegala",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Experience badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.video_call,
                              size: 12,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "3 Classes",
                              style: TextStyle(
                                color: AppColors.info,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Students count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tutor['studentsCount']} students',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ),

            // View Details Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () => _onTutorTap(tutor),
                icon: const Icon(Icons.arrow_forward_ios),
                color: AppColors.primary,
                iconSize: 16,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tutors found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedSubject != null
                ? 'Try adjusting your filter'
                : 'No tutors assigned yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          if (_selectedSubject != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedSubject = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Filter'),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Subject',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ..._subjects.map((subject) {
                return ListTile(
                  title: Text(subject),
                  leading: Radio<String>(
                    value: subject,
                    groupValue: _selectedSubject,
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value == 'All Subjects' ? null : value;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: AppColors.primary,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}