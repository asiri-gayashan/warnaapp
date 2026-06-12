import 'package:flutter/material.dart';

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
}

class TutorClassFinanceModel {
  final String id;
  final String name;
  final int grade;
  final double revenue;
  final double instituteCommission;
  final double myShare;
  final double received;
  final double pending;
  final int paidCount;
  final int unpaidCount;
  final int totalCount;

  const TutorClassFinanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.revenue,
    required this.instituteCommission,
    required this.myShare,
    required this.received,
    required this.pending,
    required this.paidCount,
    required this.unpaidCount,
    required this.totalCount,
  });
}

// ============================================================
// CONTROLLER
// ============================================================

class TutorFinanceController extends ChangeNotifier {
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
      await Future.delayed(const Duration(milliseconds: 600));

      classes = const [
        TutorClassFinanceModel(
          id: '1',
          name: 'Advanced Mathematics',
          grade: 11,
          revenue: 84000,
          instituteCommission: 21000,
          myShare: 63000,
          received: 72000,
          pending: 12000,
          paidCount: 24,
          unpaidCount: 4,
          totalCount: 28,
        ),
        TutorClassFinanceModel(
          id: '2',
          name: 'Physics Foundations',
          grade: 10,
          revenue: 67200,
          instituteCommission: 16800,
          myShare: 50400,
          received: 61600,
          pending: 5600,
          paidCount: 22,
          unpaidCount: 2,
          totalCount: 24,
        ),
        TutorClassFinanceModel(
          id: '3',
          name: 'Chemistry Basics',
          grade: 9,
          revenue: 50000,
          instituteCommission: 12500,
          myShare: 37500,
          received: 45000,
          pending: 5000,
          paidCount: 18,
          unpaidCount: 2,
          totalCount: 20,
        ),
        TutorClassFinanceModel(
          id: '4',
          name: 'Combined Maths Revision',
          grade: 12,
          revenue: 21000,
          instituteCommission: 5250,
          myShare: 15750,
          received: 17500,
          pending: 3500,
          paidCount: 5,
          unpaidCount: 1,
          totalCount: 6,
        ),
        TutorClassFinanceModel(
          id: '5',
          name: 'ICT Basics',
          grade: 8,
          revenue: 18000,
          instituteCommission: 4500,
          myShare: 13500,
          received: 18000,
          pending: 0,
          paidCount: 9,
          unpaidCount: 0,
          totalCount: 9,
        ),
      ];

      summary = const TutorFinanceSummaryModel(
        totalRevenue: 240200,
        totalReceived: 214100,
        totalPending: 26100,
        myEarnings: 180150,
      );
    } catch (e) {
      errorMessage = "Failed to load finance data";
      debugPrint("Tutor finance fetch error: $e");
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
