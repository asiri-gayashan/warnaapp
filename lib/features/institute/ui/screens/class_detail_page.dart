import 'package:flutter/material.dart';

// ── Replace these with your actual imports ──────────────────
// import 'package:warna_app/features/tutor/ui/screens/enroll_student_page.dart';
// import 'package:warna_app/features/tutor/ui/screens/fees_attendance_page.dart';
// import '../../../../core/constants/app_colors.dart';

// ── Temporary stubs (delete once real pages are imported) ────
class FeesAttendancePage extends StatelessWidget {
  const FeesAttendancePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Fees & Attendance')),
    body: const Center(child: Text('Fees & Attendance Page')),
  );
}

class EnrollStudentPage extends StatelessWidget {
  const EnrollStudentPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Enroll Student')),
    body: const Center(child: Text('Enroll Student Page')),
  );
}

class AppColors {
  static const Color primary = Color(0xff6366F1);
  static const Color textPrimary = Color(0xff111827);
  static const Color textSecondary = Color(0xff6B7280);
}
// ─────────────────────────────────────────────────────────────

// ── Data model ───────────────────────────────────────────────
class ClassItem {
  final String name;
  final String subject;
  final String grade;
  final String location;
  final int totalStudents;
  final String day;
  final String time;
  final String duration;
  final String description;
  final int paidStudents;
  final int unpaidStudents;
  final String instituteName;
  final bool institutePaymentReceived;

  const ClassItem({
    required this.name,
    required this.subject,
    required this.grade,
    required this.location,
    required this.totalStudents,
    required this.day,
    required this.time,
    required this.duration,
    required this.description,
    required this.paidStudents,
    required this.unpaidStudents,
    required this.instituteName,
    required this.institutePaymentReceived,
  });
}

// ── Dummy data ───────────────────────────────────────────────
const ClassItem _dummyClass = ClassItem(
  name: 'Science 2026',
  subject: 'Science',
  grade: 'Grade 11',
  location: 'Kurunegala',
  totalStudents: 30,
  day: 'Monday',
  time: '10:30 AM',
  duration: '60 mins',
  description:
  'A comprehensive A/L Science class covering Physics, Chemistry, and Biology '
      'fundamentals. Students will engage in theory sessions, past-paper reviews, '
      'and practicals to build a strong foundation for the 2026 examination.',
  paidStudents: 10,
  unpaidStudents: 20,
  instituteName: 'Susipwin Kurunegala',
  institutePaymentReceived: true,
);

// ── Page ─────────────────────────────────────────────────────
class ClassDetailPage extends StatelessWidget {
  /// Pass a real [ClassItem] from the calling screen; falls back to dummy data.
  final ClassItem classItem;

  const ClassDetailPage({
    Key? key,
    this.classItem = _dummyClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Class details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xffE5E7EB)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.75),
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
                        child: const Icon(Icons.menu_book,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classItem.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${classItem.subject} • ${classItem.grade}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.location_city_outlined,
                        label: classItem.location,
                      ),
                      _buildInfoChip(
                        icon: Icons.people,
                        label: '${classItem.totalStudents} students',
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: navigate to edit page
                        },
                        child: _buildInfoChip(
                          icon: Icons.edit_outlined,
                          label: 'Edit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Schedule ─────────────────────────────────────
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScheduleItem(
                      icon: Icons.calendar_today,
                      label: 'Day',
                      value: classItem.day,
                    ),
                    VerticalDivider(
                        color: Colors.grey.shade300, width: 1, thickness: 1),
                    _buildScheduleItem(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: classItem.time,
                    ),
                    VerticalDivider(
                        color: Colors.grey.shade300, width: 1, thickness: 1),
                    _buildScheduleItem(
                      icon: Icons.timer,
                      label: 'Duration',
                      value: classItem.duration,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Payment overview ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.payments,
                            color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Payment overview',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPaymentStat(
                            label: 'Paid students',
                            value: '${classItem.paidStudents}',
                            color: Colors.green,
                            icon: Icons.check_circle,
                          ),
                        ),
                        VerticalDivider(
                            color: Colors.grey.shade300,
                            width: 1,
                            thickness: 1),
                        Expanded(
                          child: _buildPaymentStat(
                            label: 'Unpaid students',
                            value: '${classItem.unpaidStudents}',
                            color: Colors.red,
                            icon: Icons.cancel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Institute payment status ──────────────────────
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
                    child: const Icon(Icons.account_balance,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.instituteName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Institute payment',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Payment status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: classItem.institutePaymentReceived
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          classItem.institutePaymentReceived
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 14,
                          color: classItem.institutePaymentReceived
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          classItem.institutePaymentReceived
                              ? 'Received'
                              : 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: classItem.institutePaymentReceived
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Description ───────────────────────────────────
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              classItem.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // ── Actions ───────────────────────────────────────
            const Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Fees & Attendance + Enroll row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FeesAttendancePage(),
                      ),
                    ),
                    icon: const Icon(Icons.receipt_long, size: 18),
                    label: const Text('Fees & Attendance'),
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
                Tooltip(
                  message: 'Enroll student',
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnrollStudentPage(),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1),
                      color: AppColors.textPrimary,
                      iconSize: 24,
                      tooltip: 'Enroll student',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Remove class button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showRemoveClassDialog(context),
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: Colors.red),
                label: const Text(
                  'Remove class',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Helper widgets ─────────────────────────────────────────

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
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildPaymentStat({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _showRemoveClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove class'),
        content: const Text(
          'Are you sure you want to remove this class? This action cannot be undone.',
        ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: call your delete API here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Class removed successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}