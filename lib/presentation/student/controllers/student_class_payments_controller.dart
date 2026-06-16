import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODEL
// ============================================================

class StudentPaymentRecord {
  final DateTime month;
  final double amount;
  String status; // 'PAID' or 'PENDING'

  StudentPaymentRecord({
    required this.month,
    required this.amount,
    required this.status,
  });
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

String studentPaymentMonthLabel(DateTime month) {
  return '${_monthNames[month.month - 1]} ${month.year}';
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentClassPaymentsController extends ChangeNotifier {
  bool isLoading = false;
  List<StudentPaymentRecord> records = [];
  String selectedFilter = 'All'; // All, Paid, Pending

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchPayments(StudentClassModel classData) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    records = List.generate(6, (i) {
      final month = DateTime(now.year, now.month - i, 1);
      final status = i == 0 ? classData.paymentStatus : 'PAID';
      return StudentPaymentRecord(
        month: month,
        amount: classData.amount,
        status: status,
      );
    });

    isLoading = false;
    notifyListeners();
  }

  // ── Computed ─────────────────────────────────────────────────
  List<StudentPaymentRecord> get filteredRecords {
    if (selectedFilter == 'Paid') {
      return records.where((r) => r.status == 'PAID').toList();
    }
    if (selectedFilter == 'Pending') {
      return records.where((r) => r.status == 'PENDING').toList();
    }
    return records;
  }

  double get totalPaid => records
      .where((r) => r.status == 'PAID')
      .fold<double>(0, (sum, r) => sum + r.amount);

  double get totalPending => records
      .where((r) => r.status == 'PENDING')
      .fold<double>(0, (sum, r) => sum + r.amount);

  int get monthsEnrolled => records.length;

  // ── Methods ──────────────────────────────────────────────────
  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void markAsPaid(int index) {
    final record = filteredRecords[index];
    if (record.status == 'PENDING') {
      record.status = 'PAID';
      notifyListeners();
    }
  }
}
