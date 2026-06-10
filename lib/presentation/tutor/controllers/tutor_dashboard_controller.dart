import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class TutorStatsModel {
  final int totalStudents;
  final int totalClasses;
  final int activeClasses;
  final double monthlyEarnings;
  final double totalCommissionReceived;

  const TutorStatsModel({
    required this.totalStudents,
    required this.totalClasses,
    required this.activeClasses,
    required this.monthlyEarnings,
    required this.totalCommissionReceived,
  });

  static TutorStatsModel empty() => const TutorStatsModel(
        totalStudents: 0,
        totalClasses: 0,
        activeClasses: 0,
        monthlyEarnings: 0,
        totalCommissionReceived: 0,
      );
}

class TutorClassPerformanceModel {
  final String id;
  final String name;
  final int grade;
  final int studentCount;
  final String subjectName;
  final String tutorName;
  final String status;

  const TutorClassPerformanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.studentCount,
    required this.subjectName,
    required this.tutorName,
    required this.status,
  });
}

class TutorUpcomingClassModel {
  final String id;
  final String name;
  final int grade;
  final String subjectName;
  final String tutorName;
  final String startTime;
  final String endTime;
  final String duration;
  final int day;

  const TutorUpcomingClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.subjectName,
    required this.tutorName,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.day,
  });

  String get dayName {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return (day >= 0 && day < days.length) ? days[day] : '';
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorDashboardController extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;

  TutorStatsModel stats = TutorStatsModel.empty();
  List<TutorClassPerformanceModel> topClasses = [];
  List<TutorClassPerformanceModel> leastClasses = [];
  List<TutorUpcomingClassModel> upcomingClasses = [];

  // ── Fetch all dashboard data ──────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      stats = const TutorStatsModel(
        totalStudents: 48,
        totalClasses: 6,
        activeClasses: 5,
        monthlyEarnings: 72000,
        totalCommissionReceived: 18000,
      );

      topClasses = const [
        TutorClassPerformanceModel(
          id: '1',
          name: 'Advanced Mathematics',
          grade: 11,
          studentCount: 28,
          subjectName: 'Mathematics',
          tutorName: 'You',
          status: 'ACTIVE',
        ),
        TutorClassPerformanceModel(
          id: '2',
          name: 'Physics Foundations',
          grade: 10,
          studentCount: 24,
          subjectName: 'Physics',
          tutorName: 'You',
          status: 'ACTIVE',
        ),
        TutorClassPerformanceModel(
          id: '3',
          name: 'Chemistry Basics',
          grade: 9,
          studentCount: 20,
          subjectName: 'Chemistry',
          tutorName: 'You',
          status: 'ACTIVE',
        ),
      ];

      leastClasses = const [
        TutorClassPerformanceModel(
          id: '4',
          name: 'Combined Maths Revision',
          grade: 12,
          studentCount: 6,
          subjectName: 'Mathematics',
          tutorName: 'You',
          status: 'ACTIVE',
        ),
        TutorClassPerformanceModel(
          id: '5',
          name: 'ICT Basics',
          grade: 8,
          studentCount: 9,
          subjectName: 'ICT',
          tutorName: 'You',
          status: 'INACTIVE',
        ),
      ];

      upcomingClasses = const [
        TutorUpcomingClassModel(
          id: '1',
          name: 'Advanced Mathematics',
          grade: 11,
          subjectName: 'Mathematics',
          tutorName: 'Bright Future Institute',
          startTime: '08:00',
          endTime: '10:00',
          duration: '2h',
          day: 1,
        ),
        TutorUpcomingClassModel(
          id: '2',
          name: 'Physics Foundations',
          grade: 10,
          subjectName: 'Physics',
          tutorName: 'Bright Future Institute',
          startTime: '10:30',
          endTime: '12:00',
          duration: '1h 30m',
          day: 1,
        ),
        TutorUpcomingClassModel(
          id: '3',
          name: 'Chemistry Basics',
          grade: 9,
          subjectName: 'Chemistry',
          tutorName: 'Star Academy',
          startTime: '14:00',
          endTime: '15:30',
          duration: '1h 30m',
          day: 3,
        ),
      ];
    } catch (e) {
      errorMessage = "Failed to load dashboard data";
      debugPrint("Tutor dashboard fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
