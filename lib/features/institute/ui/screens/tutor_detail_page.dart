import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

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
            _buildClassesTable(),

            const SizedBox(height: 24),

            // Single Action Button (only mark payment)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to mark payment page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const MarkPaymentPage(),
                  //   ),
                  // );
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

  Widget _buildClassesTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(14),
              color: AppColors.primary.withOpacity(0.04),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('Class Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 2, child: Center(child: Text('Student', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))),
                  Expanded(flex: 2, child: Text('This Month', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  Expanded(flex: 1, child: Text('Mark', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                ],
              ),
            ),

            // Table Body
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tutorClasses.length,
              itemBuilder: (context, index) {
                final classItem = _tutorClasses[index];
                final isEven = index % 2 == 0;
                final isPaid = classItem['paidStatus'] == 'Paid';

                return Container(
                  padding: const EdgeInsets.all(14),
                  color: isEven ? Colors.white : AppColors.background.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          classItem['className'],
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            '${classItem['studentCount']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isPaid ? AppColors.success : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                classItem['paidStatus'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isPaid ? AppColors.success : Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () => _toggleClassPayment(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? AppColors.success.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isPaid
                                    ? AppColors.success
                                    : AppColors.textDisabled,
                                width: 1.5,
                              ),
                            ),
                            child: isPaid
                                ? const Icon(
                              Icons.check,
                              color: AppColors.success,
                              size: 16,
                            )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}