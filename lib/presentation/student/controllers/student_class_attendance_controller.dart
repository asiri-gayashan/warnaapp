import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODEL
// ============================================================

class StudentAttendanceRecord {
  final String id;
  final DateTime date;
  final String status; // 'PRESENT' | 'ABSENT'

  const StudentAttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
  });

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

// ============================================================
// HELPERS
// ============================================================

const List<String> _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

String studentMonthLabel(DateTime month) =>
    '${_monthNames[month.month - 1]} ${month.year}';

// ============================================================
// CONTROLLER
// ============================================================

class StudentClassAttendanceController extends ChangeNotifier {
  final _dio = DioClient.instance;

  bool isLoading = false;
  List<StudentAttendanceRecord> records = [];

  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  // Last 12 months including current
  List<DateTime> get availableMonths {
    final now = DateTime.now();
    return List.generate(12, (i) {
      int month = now.month - i;
      int year = now.year;
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      return DateTime(year, month, 1);
    });
  }

  int get totalCount => records.length;
  int get presentCount => records.where((r) => r.status == 'PRESENT').length;
  int get absentCount => records.where((r) => r.status == 'ABSENT').length;

  // ── Fetch (real API) ─────────────────────────────────────────
  Future<void> fetchAttendance(StudentClassModel classData) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final response = await _dio.get(
        '/student-dashboard/attendance/${classData.id}/student/$studentUserId',
        queryParameters: {
          'month': selectedMonth.month,
          'year': selectedMonth.year,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final rawRecords = (data['records'] as List?) ?? [];
      records = rawRecords.map((r) {
        return StudentAttendanceRecord(
          id: r['id']?.toString() ?? '',
          status: r['status']?.toString() ?? 'ABSENT',
          date: DateTime.parse(r['date'].toString()).toLocal(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      records = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> changeMonth(DateTime month, StudentClassModel classData) async {
    selectedMonth = month;
    await fetchAttendance(classData);
  }
}
