import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODEL
// ============================================================

class StudentAttendanceRecord {
  final DateTime date;
  final String status; // 'PRESENT' or 'ABSENT'

  const StudentAttendanceRecord({
    required this.date,
    required this.status,
  });

  String get formattedDate =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

// ============================================================
// HELPERS
// ============================================================

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String studentMonthLabel(DateTime month) {
  return '${_monthNames[month.month - 1]} ${month.year}';
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentClassAttendanceController extends ChangeNotifier {
  bool isLoading = false;
  List<StudentAttendanceRecord> records = [];
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  List<DateTime> get availableMonths {
    final now = DateTime.now();
    return List.generate(6, (i) => DateTime(now.year, now.month - i, 1));
  }

  int get totalCount => records.length;
  int get presentCount =>
      records.where((r) => r.status == 'PRESENT').length;
  int get absentCount =>
      records.where((r) => r.status == 'ABSENT').length;

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchAttendance(StudentClassModel classData) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final daysInMonth =
        DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);

    final dates = <DateTime>[];
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, d);
      if (date.weekday == classData.day && !date.isAfter(now)) {
        dates.add(date);
      }
    }
    dates.sort((a, b) => b.compareTo(a));

    final presentTarget =
        (dates.length * classData.attendancePercentage / 100).round();

    records = [
      for (int i = 0; i < dates.length; i++)
        StudentAttendanceRecord(
          date: dates[i],
          status: i < presentTarget ? 'PRESENT' : 'ABSENT',
        ),
    ];

    isLoading = false;
    notifyListeners();
  }

  void changeMonth(DateTime month, StudentClassModel classData) {
    selectedMonth = month;
    fetchAttendance(classData);
  }
}
