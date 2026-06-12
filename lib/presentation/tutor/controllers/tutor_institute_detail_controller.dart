import 'package:flutter/material.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_institute_page_controller.dart';

class TutorInstituteDetailController extends ChangeNotifier {
  final TutorInstituteModel institute;

  TutorInstituteDetailController({required this.institute});

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoadingClasses = false;
  String? errorMessage;

  // ── Fetch the tutor's classes at this institute (dummy data) ────
  Future<void> fetchInstituteClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();

    final allClasses = [
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
        grade: 12,
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
        grade: 11,
        subjectName: 'Physics',
        tutorName: 'You',
        instituteName: 'Bright Future Institute',
        duration: '1h 30m',
      ),
      ClassModel(
        id: '3',
        name: 'Chemistry Basics',
        subjectId: '3',
        tutorId: 'me',
        instituteId: 'inst-2',
        startTime: '14:00',
        endTime: '15:30',
        day: 3,
        description:
            'Atomic structure, periodic table and chemical bonding for grade 9 students.',
        status: 'ACTIVE',
        createdAt: now.subtract(const Duration(days: 60)),
        studentCount: 20,
        amount: 3500,
        instituteCommission: 12,
        location: 'Star Academy',
        grade: 9,
        subjectName: 'Chemistry',
        tutorName: 'You',
        instituteName: 'Star Academy',
        duration: '1h 30m',
      ),
      ClassModel(
        id: '4',
        name: 'Combined Maths Revision',
        subjectId: '1',
        tutorId: 'me',
        instituteId: 'inst-1',
        startTime: '16:00',
        endTime: '18:00',
        day: 5,
        description:
            'Final revision sessions covering past papers and model questions.',
        status: 'ACTIVE',
        createdAt: now.subtract(const Duration(days: 45)),
        studentCount: 6,
        amount: 5000,
        instituteCommission: 15,
        location: 'Bright Future Institute',
        grade: 13,
        subjectName: 'Mathematics',
        tutorName: 'You',
        instituteName: 'Bright Future Institute',
        duration: '2h',
      ),
      ClassModel(
        id: '5',
        name: 'ICT Basics',
        subjectId: '4',
        tutorId: 'me',
        instituteId: 'inst-2',
        startTime: '09:00',
        endTime: '10:30',
        day: 6,
        description:
            'Introduction to computers, office tools and internet basics.',
        status: 'INACTIVE',
        createdAt: now.subtract(const Duration(days: 200)),
        studentCount: 9,
        amount: 3000,
        instituteCommission: 10,
        location: 'Star Academy',
        grade: 8,
        subjectName: 'ICT',
        tutorName: 'You',
        instituteName: 'Star Academy',
        duration: '1h 30m',
      ),
      ClassModel(
        id: '6',
        name: 'Spoken English Club',
        subjectId: '5',
        tutorId: 'me',
        instituteId: 'inst-1',
        startTime: '17:00',
        endTime: '18:00',
        day: 4,
        description:
            'Conversational English practice focused on fluency and confidence.',
        status: 'PENDING',
        createdAt: now.subtract(const Duration(days: 10)),
        studentCount: 15,
        amount: 2500,
        instituteCommission: 10,
        location: 'Bright Future Institute',
        grade: 10,
        subjectName: 'English',
        tutorName: 'You',
        instituteName: 'Bright Future Institute',
        duration: '1h',
      ),
    ];

    _classes = allClasses
        .where((cls) => cls.instituteId == institute.id)
        .toList();

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
