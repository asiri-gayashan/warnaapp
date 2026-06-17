import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODEL
// ============================================================

class StudentPaymentRecord {
  final DateTime month;
  final double amount;
  String status; // 'PAID' or 'PENDING'
  final DateTime? paidDate;
  final String? paymentMethod;

  StudentPaymentRecord({
    required this.month,
    required this.amount,
    required this.status,
    this.paidDate,
    this.paymentMethod,
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
  final _dio = DioClient.instance;

  bool isLoading = false;
  List<StudentPaymentRecord> records = [];
  String selectedFilter = 'All'; // All, Paid, Pending

  // ── Fetch (real API) ─────────────────────────────────────────
  Future<void> fetchPayments(StudentClassModel classData) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final response = await _dio.get(
        '/student-dashboard/payments/${classData.id}/student/$studentUserId',
      );
      final data = response.data as Map<String, dynamic>;
      final classAmount = (data['class_amount'] as num?)?.toDouble() ?? classData.amount;
      final rawRecords = (data['records'] as List?) ?? [];
      records = rawRecords.map((r) {
        final month = r['month'] as int;
        final year = r['year'] as int;
        final dbStatus = r['status']?.toString() ?? 'NOTPAID';
        return StudentPaymentRecord(
          month: DateTime(year, month, 1),
          amount: classAmount,
          // Map DB NOTPAID → PENDING so filter chips work
          status: dbStatus == 'PAID' ? 'PAID' : 'PENDING',
          paidDate: r['paid_date'] != null
              ? DateTime.parse(r['paid_date'].toString()).toLocal()
              : null,
          paymentMethod: r['payment_method']?.toString(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching payments: $e');
      records = [];
    }
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
    // Read-only for now — payments are marked by the tutor/institute
  }
}
