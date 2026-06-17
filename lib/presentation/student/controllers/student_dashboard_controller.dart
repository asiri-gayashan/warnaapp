import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

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

  factory StudentStatsModel.fromJson(Map<String, dynamic> j) {
    return StudentStatsModel(
      totalClasses: (j['total_classes'] as num?)?.toInt() ?? 0,
      attendancePercentage: 0,
      institutesCount: (j['institutes_count'] as num?)?.toInt() ?? 0,
      paidThisMonth: (j['paid_this_month'] ?? 0).toDouble(),
      pendingPayments: (j['pending_payments'] ?? 0).toDouble(),
      tutorsCount: (j['tutors_count'] as num?)?.toInt() ?? 0,
    );
  }
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

  factory StudentClassPerformanceModel.fromJson(Map<String, dynamic> j) {
    return StudentClassPerformanceModel(
      id: j['id']?.toString() ?? '',
      name: j['name']?.toString() ?? '',
      grade: (j['grade'] as num?)?.toInt() ?? 0,
      subjectName: j['subject_name']?.toString() ?? '',
      tutorName: j['tutor_name']?.toString() ?? '',
      attendancePercentage: 0,
      status: 'PENDING',
    );
  }
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

  factory StudentUpcomingClassModel.fromJson(Map<String, dynamic> j) {
    // DB uses 1=Mon ... 6=Sat, 7=Sun; Flutter dayName uses 0=Sun, 1=Mon ... 6=Sat
    final rawDay = (j['day'] as num?)?.toInt() ?? 0;
    final flutterDay = rawDay == 7 ? 0 : rawDay;
    return StudentUpcomingClassModel(
      id: j['id']?.toString() ?? '',
      name: j['name']?.toString() ?? '',
      grade: (j['grade'] as num?)?.toInt() ?? 0,
      subjectName: j['subject_name']?.toString() ?? '',
      tutorName: j['tutor_name']?.toString() ?? '',
      startTime: j['start_time']?.toString() ?? '',
      endTime: j['end_time']?.toString() ?? '',
      duration: '',
      day: flutterDay,
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

class StudentDashboardController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;

  StudentStatsModel stats = StudentStatsModel.empty();
  List<StudentClassPerformanceModel> topClasses = [];
  List<StudentClassPerformanceModel> leastClasses = [];
  List<StudentUpcomingClassModel> upcomingClasses = [];

  // ── Fetch all dashboard data ──────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];

      final res = await _dio.get('/student-dashboard/dashboard/$studentUserId');
      final data = res.data as Map<String, dynamic>;

      // Stats
      if (data['stats'] is Map<String, dynamic>) {
        stats = StudentStatsModel.fromJson(data['stats'] as Map<String, dynamic>);
      }

      // Pending payment classes → leastClasses
      final rawPending = data['pending_classes'];
      if (rawPending is List) {
        leastClasses = rawPending
            .map((j) => StudentClassPerformanceModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }

      // Upcoming classes
      final rawUpcoming = data['upcoming_classes'];
      if (rawUpcoming is List) {
        upcomingClasses = rawUpcoming
            .map((j) => StudentUpcomingClassModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }

      topClasses = [];
    } catch (e) {
      errorMessage = 'Failed to load dashboard data';
      debugPrint('Student dashboard fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
