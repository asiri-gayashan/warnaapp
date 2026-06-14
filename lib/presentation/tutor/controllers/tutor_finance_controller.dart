import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// MODELS
// ============================================================

class TutorFinanceSummaryModel {
  final double totalRevenue;
  final double totalReceived;
  final double totalPending;
  final double myEarnings;

  const TutorFinanceSummaryModel({
    required this.totalRevenue,
    required this.totalReceived,
    required this.totalPending,
    required this.myEarnings,
  });

  static TutorFinanceSummaryModel empty() => const TutorFinanceSummaryModel(
        totalRevenue: 0,
        totalReceived: 0,
        totalPending: 0,
        myEarnings: 0,
      );

  factory TutorFinanceSummaryModel.fromJson(Map<String, dynamic> j) {
    return TutorFinanceSummaryModel(
      totalRevenue: (j['total_revenue'] ?? 0).toDouble(),
      totalReceived: (j['total_received'] ?? 0).toDouble(),
      totalPending: (j['total_pending'] ?? 0).toDouble(),
      myEarnings: (j['my_earnings'] ?? 0).toDouble(),
    );
  }
}

class TutorClassFinanceModel {
  final String id;
  final String name;
  final int grade;

  // Institute info
  final bool hasInstitute;
  final String? instituteName;
  final double commissionPct;

  // Financial
  final double revenue;
  final double instituteCommission; // amount in Rs
  final double myShare;
  final double received;
  final double pending;

  // Student payment counts
  final int paidCount;
  final int unpaidCount;
  final int totalCount;

  // Institute payment to tutor
  final bool tutorPaidByInstitute;

  const TutorClassFinanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.hasInstitute,
    this.instituteName,
    required this.commissionPct,
    required this.revenue,
    required this.instituteCommission,
    required this.myShare,
    required this.received,
    required this.pending,
    required this.paidCount,
    required this.unpaidCount,
    required this.totalCount,
    required this.tutorPaidByInstitute,
  });

  factory TutorClassFinanceModel.fromJson(Map<String, dynamic> j) {
    return TutorClassFinanceModel(
      id: j['id'] ?? '',
      name: j['name'] ?? '',
      grade: j['grade'] ?? 0,
      hasInstitute: j['has_institute'] ?? false,
      instituteName: j['institute_name'],
      commissionPct: (j['commission_pct'] ?? 0).toDouble(),
      revenue: (j['revenue'] ?? 0).toDouble(),
      instituteCommission: (j['institute_commission'] ?? 0).toDouble(),
      myShare: (j['my_share'] ?? 0).toDouble(),
      received: (j['received'] ?? 0).toDouble(),
      pending: (j['pending'] ?? 0).toDouble(),
      paidCount: j['paid_count'] ?? 0,
      unpaidCount: j['unpaid_count'] ?? 0,
      totalCount: j['total_count'] ?? 0,
      tutorPaidByInstitute: j['tutor_paid_by_institute'] ?? false,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorFinanceController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;
  DateTime selectedMonth = DateTime.now();

  TutorFinanceSummaryModel summary = TutorFinanceSummaryModel.empty();
  List<TutorClassFinanceModel> classes = [];

  // ── Fetch all finance data ────────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final tutorId = user?['id'];
      final month = selectedMonth.month;
      final year = selectedMonth.year;

      final results = await Future.wait([
        _dio.get(
          '/tutor-finance/summary/$tutorId',
          queryParameters: {'month': month, 'year': year},
        ),
        _dio.get(
          '/tutor-finance/classes/$tutorId',
          queryParameters: {'month': month, 'year': year},
        ),
      ]);

      final summaryRes = results[0];
      final classesRes = results[1];

      if (summaryRes.data['success'] == true && summaryRes.data['data'] != null) {
        summary = TutorFinanceSummaryModel.fromJson(
          summaryRes.data['data'] as Map<String, dynamic>,
        );
      }

      if (classesRes.data['success'] == true && classesRes.data['data'] != null) {
        final List<dynamic> data = classesRes.data['data'];
        classes = data
            .map((j) => TutorClassFinanceModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      errorMessage = 'Failed to load finance data';
      debugPrint('Tutor finance fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Set month and refetch ─────────────────────────────────
  void setMonth(DateTime month) {
    selectedMonth = month;
    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
