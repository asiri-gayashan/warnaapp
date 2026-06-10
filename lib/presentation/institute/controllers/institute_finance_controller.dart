import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// MODELS
// ============================================================

class FinanceSummaryModel {
  final double commissionReceived;
  final double totalRevenue;
  final double totalReceived;
  final double totalPending;

  const FinanceSummaryModel({
    required this.commissionReceived,
    required this.totalRevenue,
    required this.totalReceived,
    required this.totalPending,
  });

  factory FinanceSummaryModel.fromJson(Map<String, dynamic> j) {
    return FinanceSummaryModel(
      commissionReceived: (j['commission_received'] ?? 0).toDouble(),
      totalRevenue:       (j['total_revenue']       ?? 0).toDouble(),
      totalReceived:      (j['total_received']       ?? 0).toDouble(),
      totalPending:       (j['total_pending']        ?? 0).toDouble(),
    );
  }

  static FinanceSummaryModel empty() => const FinanceSummaryModel(
        commissionReceived: 0,
        totalRevenue: 0,
        totalReceived: 0,
        totalPending: 0,
      );
}

class ClassFinanceModel {
  final String id;
  final String name;
  final int grade;
  final String tutorName;
  final bool teacherPaid;
  final double revenue;
  final double commission;
  final double received;
  final double pending;
  final int paidCount;
  final int unpaidCount;
  final int totalCount;

  const ClassFinanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.tutorName,
    required this.teacherPaid,
    required this.revenue,
    required this.commission,
    required this.received,
    required this.pending,
    required this.paidCount,
    required this.unpaidCount,
    required this.totalCount,
  });

  factory ClassFinanceModel.fromJson(Map<String, dynamic> j) {
    return ClassFinanceModel(
      id:          j['id']           ?? '',
      name:        j['name']         ?? '',
      grade:       j['grade']        ?? 0,
      tutorName:   j['tutor_name']   ?? '',
      teacherPaid: j['teacher_paid'] ?? false,
      revenue:     (j['revenue']     ?? 0).toDouble(),
      commission:  (j['commission']  ?? 0).toDouble(),
      received:    (j['received']    ?? 0).toDouble(),
      pending:     (j['pending']     ?? 0).toDouble(),
      paidCount:   j['paid_count']   ?? 0,
      unpaidCount: j['unpaid_count'] ?? 0,
      totalCount:  j['total_count']  ?? 0,
    );
  }
}

class TeacherFinanceModel {
  final String tutorId;
  final String tutorName;
  final String className;
  final int grade;
  final double commission;
  final bool paid;

  const TeacherFinanceModel({
    required this.tutorId,
    required this.tutorName,
    required this.className,
    required this.grade,
    required this.commission,
    required this.paid,
  });

  factory TeacherFinanceModel.fromJson(Map<String, dynamic> j) {
    return TeacherFinanceModel(
      tutorId:    j['tutor_id']    ?? '',
      tutorName:  j['tutor_name']  ?? '',
      className:  j['class_name']  ?? '',
      grade:      j['grade']       ?? 0,
      commission: (j['commission'] ?? 0).toDouble(),
      paid:       j['paid']        ?? false,
    );
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class InstituteFinanceController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  String? errorMessage;
  DateTime selectedMonth = DateTime.now();

  FinanceSummaryModel summary = FinanceSummaryModel.empty();
  List<ClassFinanceModel>   classes  = [];
  List<TeacherFinanceModel> teachers = [];

  // ── Query helpers ─────────────────────────────────────────
  int get _month => selectedMonth.month;
  int get _year  => selectedMonth.year;

  Map<String, dynamic> get _query => {
        'month': _month.toString(),
        'year':  _year.toString(),
      };

  // ── Fetch all ─────────────────────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final id   = user?["id"] as String?;
      if (id == null) throw Exception("User not found");

      final results = await Future.wait([
        _dio.get("/institute/data/finance/summary/$id",
            queryParameters: _query),
        _dio.get("/institute/data/finance/classes/$id",
            queryParameters: _query),
        _dio.get("/institute/data/finance/teachers/$id",
            queryParameters: _query),
      ]);

      // Summary
      if (results[0].data['success'] == true) {
        summary = FinanceSummaryModel.fromJson(
            results[0].data['data'] as Map<String, dynamic>);
      }

      // Classes
      if (results[1].data['success'] == true) {
        classes = (results[1].data['data'] as List)
            .map((j) => ClassFinanceModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }

      // Teachers
      if (results[2].data['success'] == true) {
        teachers = (results[2].data['data'] as List)
            .map((j) =>
                TeacherFinanceModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      errorMessage = "Failed to load finance data";
      debugPrint("Finance fetch error: $e");
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