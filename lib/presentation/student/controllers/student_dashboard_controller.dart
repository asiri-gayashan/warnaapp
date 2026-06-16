import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODELS
// ============================================================

class StudentStatsModel {
  final int totalClasses;
  final double attendancePercentage;
  final int institutesCount;
  final double paidThisMonth;
  final double pendingPayments;
  final int tutorsCount;

  const StudentStatsModel({
    required this.totalClasses,
    required this.attendancePercentage,
    required this.institutesCount,
    required this.paidThisMonth,
    required this.pendingPayments,
    required this.tutorsCount,
  });

  static StudentStatsModel empty() => const StudentStatsModel(
        totalClasses: 0,
        attendancePercentage: 0,
        institutesCount: 0,
        paidThisMonth: 0,
        pendingPayments: 0,
        tutorsCount: 0,
      );
}

class StudentClassPerformanceModel {
  final String id;
  final String name;
  final int grade;
  final String subjectName;
  final String tutorName;
  final int attendancePercentage;
  final String status;

  const StudentClassPerformanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.subjectName,
    required this.tutorName,
    required this.attendancePercentage,
    required this.status,
  });
}

class StudentUpcomingClassModel {
  final String id;
  final String name;
  final int grade;
  final String subjectName;
  final String tutorName;
  final String startTime;
  final String endTime;
  final String duration;
  final int day;

  const StudentUpcomingClassModel({
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

class StudentDashboardController extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;

  StudentStatsModel stats = StudentStatsModel.empty();
  List<StudentClassPerformanceModel> topClasses = [];
  List<StudentClassPerformanceModel> leastClasses = [];
  List<StudentUpcomingClassModel> upcomingClasses = [];

  // ── Fetch all dashboard data (dummy) ──────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    final classes = studentDummyClasses;

    final totalAttendance = classes.fold<int>(
      0,
      (sum, c) => sum + c.attendancePercentage,
    );
    final paidThisMonth = classes
        .where((c) => c.paymentStatus == 'PAID')
        .fold<double>(0, (sum, c) => sum + c.amount);
    final pendingPayments = classes
        .where((c) => c.paymentStatus == 'PENDING')
        .fold<double>(0, (sum, c) => sum + c.amount);
    final institutesCount =
        classes.map((c) => c.instituteId).whereType<String>().toSet().length;
    final tutorsCount = classes.map((c) => c.tutorId).toSet().length;

    stats = StudentStatsModel(
      totalClasses: classes.length,
      attendancePercentage: classes.isEmpty
          ? 0
          : (totalAttendance / classes.length).roundToDouble(),
      institutesCount: institutesCount,
      paidThisMonth: paidThisMonth,
      pendingPayments: pendingPayments,
      tutorsCount: tutorsCount,
    );

    final sortedByAttendance = [...classes]
      ..sort((a, b) => b.attendancePercentage.compareTo(a.attendancePercentage));

    topClasses = sortedByAttendance
        .take(3)
        .map((c) => StudentClassPerformanceModel(
              id: c.id,
              name: c.name,
              grade: c.grade,
              subjectName: c.subjectName,
              tutorName: c.tutorName,
              attendancePercentage: c.attendancePercentage,
              status: c.status,
            ))
        .toList();

    leastClasses = sortedByAttendance.reversed
        .take(3)
        .map((c) => StudentClassPerformanceModel(
              id: c.id,
              name: c.name,
              grade: c.grade,
              subjectName: c.subjectName,
              tutorName: c.tutorName,
              attendancePercentage: c.attendancePercentage,
              status: c.status,
            ))
        .toList();

    upcomingClasses = classes
        .map((c) => StudentUpcomingClassModel(
              id: c.id,
              name: c.name,
              grade: c.grade,
              subjectName: c.subjectName,
              tutorName: c.tutorName,
              startTime: c.startTime,
              endTime: c.endTime,
              duration: c.duration,
              day: c.day == 7 ? 0 : c.day,
            ))
        .toList();

    isLoading = false;
    notifyListeners();
  }
}
