import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';

// ============================================================
// MODELS
// ============================================================

class StudentFinanceSummaryModel {
  final double totalFees;
  final double totalPaid;
  final double totalPending;

  const StudentFinanceSummaryModel({
    required this.totalFees,
    required this.totalPaid,
    required this.totalPending,
  });

  static StudentFinanceSummaryModel empty() =>
      const StudentFinanceSummaryModel(
        totalFees: 0,
        totalPaid: 0,
        totalPending: 0,
      );
}

class StudentClassFinanceModel {
  final String id;
  final String name;
  final int grade;
  final double monthlyFee;
  final String tutorName;
  final String? instituteName;
  final String paymentStatus; // for selected month: 'PAID' or 'PENDING'
  final int paidMonths;
  final int pendingMonths;
  final int totalMonths;

  const StudentClassFinanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.monthlyFee,
    required this.tutorName,
    this.instituteName,
    required this.paymentStatus,
    required this.paidMonths,
    required this.pendingMonths,
    required this.totalMonths,
  });
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentFinanceController extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  StudentFinanceSummaryModel summary = StudentFinanceSummaryModel.empty();
  List<StudentClassFinanceModel> classes = [];

  // ── Fetch all finance data (dummy) ────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final isCurrentMonth = selectedMonth.year == currentMonth.year &&
        selectedMonth.month == currentMonth.month;

    // Determine if selectedMonth falls in the last 6 months
    bool isInRange = false;
    for (int i = 0; i < 6; i++) {
      final m = DateTime(now.year, now.month - i, 1);
      if (m.year == selectedMonth.year && m.month == selectedMonth.month) {
        isInRange = true;
        break;
      }
    }

    classes = studentDummyClasses.map((cls) {
      // Current month reflects actual paymentStatus; all previous = PAID.
      final monthStatus = (!isInRange || !isCurrentMonth)
          ? 'PAID'
          : cls.paymentStatus;

      return StudentClassFinanceModel(
        id: cls.id,
        name: cls.name,
        grade: cls.grade,
        monthlyFee: cls.amount,
        tutorName: cls.tutorName,
        instituteName: cls.instituteName,
        paymentStatus: monthStatus,
        paidMonths: cls.paymentStatus == 'PAID' ? 6 : 5,
        pendingMonths: cls.paymentStatus == 'PENDING' ? 1 : 0,
        totalMonths: 6,
      );
    }).toList();

    final totalFees =
        classes.fold<double>(0, (sum, c) => sum + c.monthlyFee);
    final totalPaid = classes
        .where((c) => c.paymentStatus == 'PAID')
        .fold<double>(0, (sum, c) => sum + c.monthlyFee);

    summary = StudentFinanceSummaryModel(
      totalFees: totalFees,
      totalPaid: totalPaid,
      totalPending: totalFees - totalPaid,
    );

    isLoading = false;
    notifyListeners();
  }

  // ── Set month and refetch ─────────────────────────────────
  void setMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month, 1);
    fetchAll();
  }
}
