import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// MODELS
// ============================================================

class TutorStatsModel {
  final int totalStudents;
  final int totalClasses;
  final int instituteCount;
  final double monthlyEarnings;
  final double totalCommissionReceived;

  const TutorStatsModel({
    required this.totalStudents,
    required this.totalClasses,
    required this.instituteCount,
    required this.monthlyEarnings,
    required this.totalCommissionReceived,
  });

  factory TutorStatsModel.fromJson(Map<String, dynamic> j) {
    return TutorStatsModel(
      totalStudents: j['total_students'] ?? 0,
      totalClasses: j['total_classes'] ?? 0,
      instituteCount: j['institute_count'] ?? 0,
      monthlyEarnings: (j['monthly_earnings'] ?? 0).toDouble(),
      totalCommissionReceived:
          (j['total_commission_received'] ?? 0).toDouble(),
    );
  }

  static TutorStatsModel empty() => const TutorStatsModel(
        totalStudents: 0,
        totalClasses: 0,
        instituteCount: 0,
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

  factory TutorClassPerformanceModel.fromJson(Map<String, dynamic> j) {
    return TutorClassPerformanceModel(
      id: j['id'] ?? '',
      name: j['name'] ?? '',
      grade: j['grade'] ?? 0,
      studentCount: j['student_count'] ?? 0,
      subjectName: j['subject_name'] ?? '',
      tutorName: j['tutor_name'] ?? '',
      status: j['status'] ?? '',
    );
  }
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

  factory TutorUpcomingClassModel.fromJson(Map<String, dynamic> j) {
    return TutorUpcomingClassModel(
      id: j['id'] ?? '',
      name: j['name'] ?? '',
      grade: j['grade'] ?? 0,
      subjectName: j['subject_name'] ?? '',
      tutorName: j['tutor_name'] ?? '',
      startTime: j['start_time'] ?? '',
      endTime: j['end_time'] ?? '',
      duration: j['duration'] ?? '',
      day: j['day'] ?? 0,
    );
  }

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
  final _dio = DioClient.instance;

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
      final user = await UserService.getUser();
      final tutorId = user?["id"];

      final results = await Future.wait([
        _dio.get("/tutor-dashboard/stats/$tutorId"),
        _dio.get("/tutor-dashboard/performance/$tutorId"),
        _dio.get("/tutor-dashboard/upcoming/$tutorId"),
      ]);

      final statsRes = results[0];
      final perfRes = results[1];
      final upcomingRes = results[2];

      if (statsRes.data['success'] == true) {
        stats = TutorStatsModel.fromJson(statsRes.data['data']);
      }

      if (perfRes.data['success'] == true) {
        final data = perfRes.data['data'];
        topClasses = (data['top_classes'] as List)
            .map((j) => TutorClassPerformanceModel.fromJson(j))
            .toList();
        leastClasses = (data['least_classes'] as List)
            .map((j) => TutorClassPerformanceModel.fromJson(j))
            .toList();
      }

      if (upcomingRes.data['success'] == true) {
        upcomingClasses = (upcomingRes.data['data'] as List)
            .map((j) => TutorUpcomingClassModel.fromJson(j))
            .toList();
      }
    } catch (e) {
      errorMessage = "Failed to load dashboard data";
      debugPrint("Tutor dashboard fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
