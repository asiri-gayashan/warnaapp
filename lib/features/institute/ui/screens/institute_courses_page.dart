import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/features/institute/ui/screens/class_detail_page.dart';
import 'package:warna_app/features/institute/ui/screens/institute_create_class.dart';
import '../../../../shared/widgets/new/course_card.dart';

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
          'My Classes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleCourses.length,
        itemBuilder: (context, index) {
          final course = sampleCourses[index];
          return CourseCard(
            title: course.title,
            subject: course.subject,
            grade: course.grade,
            location: course.location,
            day: course.day,
            time: course.time,
            duration: course.duration,
            studentCount: course.studentCount,
            dayColor: course.dayColor,
            dayBg: course.dayBg,
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassDetailPage()),
              );
            },
          );
        },
      ),

      //Floating action  button to add new course
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InstituteCreateClassPage()),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 10,
        child: const Icon(Icons.add),
      ),
    );
  }
}

