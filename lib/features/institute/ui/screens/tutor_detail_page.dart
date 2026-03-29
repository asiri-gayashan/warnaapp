import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/features/institute/ui/screens/mark_payement_teachers_page.dart';

class TutorDetailPage extends StatefulWidget {
  final Map<String, dynamic> tutor;

  const TutorDetailPage({Key? key, required this.tutor}) : super(key: key);

  @override
  State<TutorDetailPage> createState() => _TutorDetailPageState();
}

class _TutorDetailPageState extends State<TutorDetailPage> {
  // Sample classes data for the tutor
  final List<Map<String, dynamic>> _tutorClasses = [
    {
      'id': 'C001',
      'className': 'Advanced Mathematics - Grade 10',
      'studentCount': 15,
      'paidStatus': 'Paid',
    },
    {
      'id': 'C002',
      'className': 'Physics Fundamentals - Grade 11',
      'studentCount': 12,
      'paidStatus': 'Not Paid',
    },
    {
      'id': 'C003',
      'className': 'Chemistry Lab - Grade 10',
      'studentCount': 10,
      'paidStatus': 'Paid',
    },
    {
      'id': 'C004',
      'className': 'English Literature - Grade 9',
      'studentCount': 18,
      'paidStatus': 'Not Paid',
    },
  ];

  void _toggleClassPayment(int index) {
    setState(() {
      _tutorClasses[index]['paidStatus'] =
      _tutorClasses[index]['paidStatus'] == 'Paid' ? 'Not Paid' : 'Paid';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
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
                    widget.tutor['id'],
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
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Experience', widget.tutor['experience']),
                  _buildStatColumn('Rating', '${widget.tutor['rating']} ⭐'),
                  _buildStatColumn('Students', '${widget.tutor['studentsCount']}'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.email_outlined, 'Email', widget.tutor['email']),
            _buildInfoTile(Icons.phone_outlined, 'Mobile', widget.tutor['phone']),

            const SizedBox(height: 24),

            // Personal Information
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.lock_outlined, 'Password', '••••••••'),
            _buildInfoTile(Icons.location_on_outlined, 'Province', widget.tutor['province'] ?? 'Western'),
            _buildInfoTile(Icons.home_outlined, 'Address', widget.tutor['address'] ?? 'Colombo, Sri Lanka'),

            const SizedBox(height: 24),

            // Professional Information
            const Text(
              'Professional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.menu_book_outlined, 'Subject', widget.tutor['subject']),
            _buildInfoTile(Icons.work_outline, 'Qualification', widget.tutor['qualification']),

            const SizedBox(height: 24),

            // Classes Section
            const Text(
              'Assigned Classes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
                  _buildUpcomingClassItem(
                    'Advanced Mathematics',
                    'Grade 10',
                    '9:00 AM - 10:30 AM',
                    'Mr. Kumar',
                    'Room 101',
                  ),
                  _buildUpcomingClassItem(
                    'Physics Fundamentals',
                    'Grade 11',
                    '10:45 AM - 12:15 PM',
                    'Ms. Sharma',
                    'Lab 3',
                  ),
                  _buildUpcomingClassItem(
                    'English Literature',
                    'Grade 9',
                    '1:00 PM - 2:30 PM',
                    'Mrs. Singh',
                    'Room 205',
                  ),
                  _buildUpcomingClassItem(
                    'Chemistry Lab',
                    'Grade 10',
                    '2:45 PM - 4:15 PM',
                    'Dr. Verma',
                    'Lab 1',
                  ),
                  _buildUpcomingClassItem(
                    'Computer Science',
                    'Grade 11',
                    '4:30 PM - 6:00 PM',
                    'Mr. Patil',
                    'Computer Lab',
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

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClassItem(
      String className,
      String grade,
      String time,
      String teacher,
      String room,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sailing,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  className,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$grade • $teacher',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                room,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}



