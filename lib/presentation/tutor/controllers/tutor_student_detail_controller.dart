import 'package:flutter/material.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_student_page_controller.dart';

class TutorStudentDetailController extends ChangeNotifier {
  final TutorStudentModel student;

  TutorStudentDetailController({required this.student});

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoadingClasses = false;
  String? errorMessage;

  // ── Fetch classes this student is enrolled in (dummy data) ────
  Future<void> fetchStudentClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    _classes = [
      ClassModel(
        id: '1',
        name: 'Advanced Mathematics',
        subjectId: '1',
        tutorId: 'me',
        instituteId: 'inst-1',
        startTime: '08:00',
        endTime: '10:00',
        day: 1,
        description:
            'In-depth coverage of algebra, calculus and geometry for A/L students.',
        status: 'ACTIVE',
        createdAt: now.subtract(const Duration(days: 120)),
        studentCount: 28,
        amount: 4500,
        instituteCommission: 15,
        location: 'Bright Future Institute',
        grade: student.grade,
        subjectName: 'Mathematics',
        tutorName: 'You',
        instituteName: 'Bright Future Institute',
        duration: '2h',
      ),
      ClassModel(
        id: '2',
        name: 'Physics Foundations',
        subjectId: '2',
        tutorId: 'me',
        instituteId: 'inst-1',
        startTime: '10:30',
        endTime: '12:00',
        day: 1,
        description:
            'Mechanics, waves and thermodynamics fundamentals with practical examples.',
        status: 'ACTIVE',
        createdAt: now.subtract(const Duration(days: 90)),
        studentCount: 24,
        amount: 4000,
        instituteCommission: 15,
        location: 'Bright Future Institute',
        grade: student.grade,
        subjectName: 'Physics',
        tutorName: 'You',
        instituteName: 'Bright Future Institute',
        duration: '1h 30m',
      ),
    ];

    isLoadingClasses = false;
    notifyListeners();
  }

  // ── Day number → name ─────────────────────────────────────────
  String dayName(int day) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return (day >= 0 && day < days.length) ? days[day] : 'Unknown';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
