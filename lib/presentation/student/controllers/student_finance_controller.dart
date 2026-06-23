import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

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

  factory StudentFinanceSummaryModel.fromJson(Map<String, dynamic> j) {
    return StudentFinanceSummaryModel(
      totalFees: (j['total_fees'] ?? 0).toDouble(),
      totalPaid: (j['total_paid'] ?? 0).toDouble(),
      totalPending: (j['total_pending'] ?? 0).toDouble(),
    );
  }
}

class StudentClassFinanceModel {
  final String id;
  final String name;
  final int grade;
  final double monthlyFee;
  final String tutorName;
  final String? instituteName;
  final String paymentStatus; // 'PAID' or 'PENDING' for selected month
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

  factory StudentClassFinanceModel.fromJson(Map<String, dynamic> j) {
    return StudentClassFinanceModel(
      id: j['id']?.toString() ?? '',
      name: j['name']?.toString() ?? '',
      grade: (j['grade'] as num?)?.toInt() ?? 0,
      monthlyFee: (j['monthly_fee'] ?? 0).toDouble(),
      tutorName: j['tutor_name']?.toString() ?? '',
      instituteName: j['institute_name']?.toString(),
      paymentStatus: j['payment_status']?.toString() ?? 'PENDING',
      paidMonths: (j['paid_months'] as num?)?.toInt() ?? 0,
      pendingMonths: (j['pending_months'] as num?)?.toInt() ?? 0,
      totalMonths: (j['total_months'] as num?)?.toInt() ?? 0,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class StudentFinanceController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

  StudentFinanceSummaryModel summary = StudentFinanceSummaryModel.empty();
  List<StudentClassFinanceModel> classes = [];

  // ── Fetch all finance data ────────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final month = selectedMonth.month;
      final year = selectedMonth.year;

      final results = await Future.wait([
        _dio.get(
          '/student-dashboard/finance/summary/$studentUserId',
          queryParameters: {'month': month, 'year': year},
        ),
        _dio.get(
          '/student-dashboard/finance/classes/$studentUserId',
          queryParameters: {'month': month, 'year': year},
        ),
      ]);

      final summaryRes = results[0];
      final classesRes = results[1];

      // Summary — flat object response
      final summaryData = summaryRes.data;
      if (summaryData is Map<String, dynamic>) {
        summary = StudentFinanceSummaryModel.fromJson(summaryData);
      }

      // Classes — flat array response
      final List<dynamic> raw = classesRes.data is List
          ? List<dynamic>.from(classesRes.data as List)
          : List<dynamic>.from((classesRes.data['data'] as List?) ?? []);
      classes = raw
          .map((j) => StudentClassFinanceModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      errorMessage = 'Failed to load finance data';
      debugPrint('Student finance fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Set month and refetch ─────────────────────────────────
  void setMonth(DateTime month) {
    selectedMonth = DateTime(month.year, month.month, 1);
    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
