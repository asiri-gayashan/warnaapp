import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/features/institute/ui/screens/mark_payement_teachers_page.dart';
import '../../../../shared/widgets/new/stat_column.dart';
import '../../../../shared/widgets/new/info_tile.dart';
import '../../../../shared/widgets/new/upcoming_class_list_tile.dart';

class TutorDetailPage extends StatefulWidget {
  final Map<String, dynamic> tutor;

  const TutorDetailPage({Key? key, required this.tutor}) : super(key: key);

  @override
  State<TutorDetailPage> createState() => _TutorDetailPageState();
}

class _TutorDetailPageState extends State<TutorDetailPage> {
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
          'Tutor Details',
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
            // Tutor Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      widget.tutor['name'][0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.tutor['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "example@gmail.com",
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
                  StatColumn(
                    label: 'Experience',
                    value: widget.tutor['experience'],
                  ),
                  StatColumn(label: 'Classes', value: '10'),
                  StatColumn(
                    label: 'Students',
                    value: '${widget.tutor['studentsCount']}',
                  ),
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
              value: widget.tutor['email'],
            ),
            InfoTile(
              icon: Icons.phone_outlined,
              label: 'Mobile',
              value: widget.tutor['phone'],
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
              value: widget.tutor['district'] ?? 'Colombo',
            ),
            InfoTile(
              icon: Icons.route,
              label: 'Postal Code',
              value: widget.tutor['postCode'] ?? '00000',
            ),
            InfoTile(
              icon: Icons.home_outlined,
              label: 'Address',
              value: widget.tutor['address'] ?? 'Colombo, Sri Lanka',
            ),

            const SizedBox(height: 24),

            // Professional Information
            const Text(
              'Professional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InfoTile(
              icon: Icons.menu_book_outlined,
              label: 'Subject',
              value: widget.tutor['subject'],
            ),
            InfoTile(icon: Icons.work_outline, label: 'Grade', value: '10'),

            const SizedBox(height: 24),

            // Classes Section
            const Text(
              'Assigned Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),
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

            // Single Action Button (only mark payment)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to mark payment page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InstituteMarkPaymentPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Mark Payments'),
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

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
