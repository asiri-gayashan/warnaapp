import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';



// --- Data model ---
class CourseData {
  final String title;
  final String subject;
  final String grade;
  final String location;
  final String day;
  final String time;
  final String duration;
  final int studentCount;
  final Color dayColor;
  final Color dayBg;

  const CourseData({
    required this.title,
    required this.subject,
    required this.grade,
    required this.location,
    required this.day,
    required this.time,
    required this.duration,
    required this.studentCount,
    required this.dayColor,
    required this.dayBg,
  });
}

// --- Sample data ---
const List<CourseData> sampleCourses = [
  CourseData(
    title: 'Science 2026',
    subject: 'Science',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Monday',
    time: '10:30 AM',
    duration: '60 mins',
    studentCount: 8,
    dayColor: Color(0xff185FA5),
    dayBg: Color(0xffE8F2FF),
  ),
  CourseData(
    title: 'Pure Maths 2026',
    subject: 'Mathematics',
    grade: 'Grade 12',
    location: 'Colombo',
    day: 'Wednesday',
    time: '2:00 PM',
    duration: '90 mins',
    studentCount: 12,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Physics 2026',
    subject: 'Physics',
    grade: 'Grade 11',
    location: 'Kandy',
    day: 'Friday',
    time: '9:00 AM',
    duration: '75 mins',
    studentCount: 6,
    dayColor: Color(0xff993C1D),
    dayBg: Color(0xffFAECE7),
  ),
  CourseData(
    title: 'Combined Maths',
    subject: 'Mathematics',
    grade: 'Grade 12',
    location: 'Gampaha',
    day: 'Tuesday',
    time: '3:30 PM',
    duration: '90 mins',
    studentCount: 15,
    dayColor: Color(0xff185FA5),
    dayBg: Color(0xffE8F2FF),
  ),
  CourseData(
    title: 'Chemistry 2026',
    subject: 'Chemistry',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Thursday',
    time: '11:00 AM',
    duration: '60 mins',
    studentCount: 10,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Biology 2026',
    subject: 'Biology',
    grade: 'Grade 12',
    location: 'Colombo',
    day: 'Saturday',
    time: '8:00 AM',
    duration: '120 mins',
    studentCount: 18,
    dayColor: Color(0xff993C1D),
    dayBg: Color(0xffFAECE7),
  ),
];

// --- Avatar initials colors ---
const List<Color> _avatarBgColors = [
  Color(0xffEEEDFE),
  Color(0xffE1F5EE),
  Color(0xffFAECE7),
];

const List<Color> _avatarTextColors = [
  Color(0xff3C3489),
  Color(0xff0F6E56),
  Color(0xff993C1D),
];

// ============================================================
// MAIN PAGE
// ============================================================

class InstituteCoursesPage extends StatelessWidget {
  const InstituteCoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Course management',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xffE5E7EB)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xffE5E7EB), width: 0.5),
            ),
            child: Text(
              '${sampleCourses.length} active',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleCourses.length,
        itemBuilder: (context, index) {
          return _CourseCard(course: sampleCourses[index]);
        },
      ),
    );
  }
}

// ============================================================
// COURSE CARD
// ============================================================

class _CourseCard extends StatelessWidget {
  final CourseData course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5E7EB), width: 0.5),
      ),
      child: Column(
        children: [
          // ── TOP SECTION ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SubjectBadge(label: course.subject),
                    _DayBadge(
                      label: course.day,
                      bg: course.dayBg,
                      textColor: course.dayColor,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 3),

                // Subtitle
                Text(
                  '${course.grade} · Advanced Level',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 14),

                // Tag chips
                Row(
                  children: [
                    _TagChip(
                      icon: Icons.school_outlined,
                      label: course.grade,
                      bg: const Color(0xffEEEDFE),
                      iconColor: const Color(0xff3C3489),
                      textColor: const Color(0xff3C3489),
                    ),
                    const SizedBox(width: 8),
                    _TagChip(
                      icon: Icons.place_outlined,
                      label: course.location,
                      bg: const Color(0xffF3F4F6),
                      iconColor: AppColors.textSecondary,
                      textColor: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── DIVIDER ──────────────────────────────────────────
          Container(height: 0.5, color: const Color(0xffE5E7EB)),

          // ── META ROW (time + duration) ────────────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _MetaItem(
                    iconWidget: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F1FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: Color(0xff185FA5),
                      ),
                    ),
                    label: 'Time',
                    value: course.time,
                  ),
                ),
                Container(
                  width: 0.5,
                  color: const Color(0xffE5E7EB),
                ),
                Expanded(
                  child: _MetaItem(
                    iconWidget: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xffE1F5EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Color(0xff0F6E56),
                      ),
                    ),
                    label: 'Duration',
                    value: course.duration,
                  ),
                ),
              ],
            ),
          ),

          // ── DIVIDER ──────────────────────────────────────────
          Container(height: 0.5, color: const Color(0xffE5E7EB)),

          // ── FOOTER (students + button) ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 13, 18, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StudentAvatars(count: course.studentCount),
                _ViewButton(onTap: () {


                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SUB-WIDGETS
// ============================================================

class _SubjectBadge extends StatelessWidget {
  final String label;
  const _SubjectBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE5E7EB), width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  const _DayBadge({
    required this.label,
    required this.bg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color iconColor;
  final Color textColor;

  const _TagChip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final String value;

  const _MetaItem({
    required this.iconWidget,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _StudentAvatars extends StatelessWidget {
  final int count;
  const _StudentAvatars({required this.count});

  @override
  Widget build(BuildContext context) {
    final shown = count > 3 ? 3 : count;
    final extra = count - shown;

    return Row(
      children: [
        SizedBox(
          width: (shown * 22.0) + (extra > 0 ? 30 : 0),
          height: 28,
          child: Stack(
            children: [
              for (int i = 0; i < shown; i++)
                Positioned(
                  left: i * 20.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _avatarBgColors[i % _avatarBgColors.length],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(i),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _avatarTextColors[i % _avatarTextColors.length],
                      ),
                    ),
                  ),
                ),
              if (extra > 0)
                Positioned(
                  left: shown * 20.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F4F6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$extra',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count students',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _initials(int i) {
    const names = ['AK', 'BR', 'CM', 'DL', 'EP', 'FN'];
    return names[i % names.length];
  }
}

class _ViewButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}