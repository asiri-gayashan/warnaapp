import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

// ============================================================
// MODELS
// ============================================================

class InstituteStatsModel {
  final int totalStudents;
  final int totalTutors;
  final int totalClasses;
  final int activeClasses;
  final double monthlyRevenue;
  final double totalCommission;

  const InstituteStatsModel({
    required this.totalStudents,
    required this.totalTutors,
    required this.totalClasses,
    required this.activeClasses,
    required this.monthlyRevenue,
    required this.totalCommission,
  });

  factory InstituteStatsModel.fromJson(Map<String, dynamic> j) {
    return InstituteStatsModel(
      totalStudents:    j['total_students']   ?? 0,
      totalTutors:      j['total_tutors']     ?? 0,
      totalClasses:     j['total_classes']    ?? 0,
      activeClasses:    j['active_classes']   ?? 0,
      monthlyRevenue:   (j['monthly_revenue'] ?? 0).toDouble(),
      totalCommission:  (j['total_commission'] ?? 0).toDouble(),
    );
  }

  static InstituteStatsModel empty() => const InstituteStatsModel(
        totalStudents: 0,
        totalTutors: 0,
        totalClasses: 0,
        activeClasses: 0,
        monthlyRevenue: 0,
        totalCommission: 0,
      );
}

class ClassPerformanceModel {
  final String id;
  final String name;
  final int grade;
  final int studentCount;
  final String subjectName;
  final String tutorName;
  final String status;

  const ClassPerformanceModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.studentCount,
    required this.subjectName,
    required this.tutorName,
    required this.status,
  });

  factory ClassPerformanceModel.fromJson(Map<String, dynamic> j) {
    return ClassPerformanceModel(
      id:           j['id']            ?? '',
      name:         j['name']          ?? '',
      grade:        j['grade']         ?? 0,
      studentCount: j['student_count'] ?? 0,
      subjectName:  j['subject_name']  ?? '',
      tutorName:    j['tutor_name']    ?? '',
      status:       j['status']        ?? '',
    );
  }
}

class UpcomingClassModel {
  final String id;
  final String name;
  final int grade;
  final String subjectName;
  final String tutorName;
  final String startTime;
  final String endTime;
  final String duration;
  final int day;

  const UpcomingClassModel({
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

  factory UpcomingClassModel.fromJson(Map<String, dynamic> j) {
    return UpcomingClassModel(
      id:          j['id']           ?? '',
      name:        j['name']         ?? '',
      grade:       j['grade']        ?? 0,
      subjectName: j['subject_name'] ?? '',
      tutorName:   j['tutor_name']   ?? '',
      startTime:   j['start_time']   ?? '',
      endTime:     j['end_time']     ?? '',
      duration:    j['duration']     ?? '',
      day:         j['day']          ?? 0,
    );
  }

  String get dayName {
    const days = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday'
    ];
    return (day >= 0 && day < days.length) ? days[day] : '';
  }
}

// ── Report types ─────────────────────────────────────────────
enum ReportType { classes, students, tutors }

class ReportFilter {
  final String? grade;
  final String? status;
  final String? subjectId;
  final String? districtId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ReportFilter({
    this.grade,
    this.status,
    this.subjectId,
    this.districtId,
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      if (grade != null)      'grade':       grade,
      if (status != null)     'status':      status,
      if (subjectId != null)  'subject_id':  subjectId,
      if (districtId != null) 'district_id': districtId,
      if (fromDate != null)
        'from': fromDate!.toIso8601String().substring(0, 10),
      if (toDate != null)
        'to':   toDate!.toIso8601String().substring(0, 10),
    };
  }
}

// ============================================================
// CONTROLLER
// ============================================================

class InstituteDashboardController extends ChangeNotifier {
  final _dio = DioClient.instance;

  // ── State ─────────────────────────────────────────────────
  bool isLoading = false;
  bool isExporting = false;
  String? errorMessage;

  InstituteStatsModel stats = InstituteStatsModel.empty();
  List<ClassPerformanceModel> topClasses    = [];
  List<ClassPerformanceModel> leastClasses  = [];
  List<UpcomingClassModel>    upcomingClasses = [];

  // ── Fetch all dashboard data ──────────────────────────────
  Future<void> fetchAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final id   = user?["id"] as String?;
      if (id == null) throw Exception("User not found");

      final results = await Future.wait([
        _dio.get("/institute/stats/$id"),
        _dio.get("/institute/performance/$id"),
        _dio.get("/institute/upcoming/$id"),
      ]);

      // Stats
      if (results[0].data['success'] == true) {
        stats = InstituteStatsModel.fromJson(
            results[0].data['data'] as Map<String, dynamic>);
      }

      // Performance
      if (results[1].data['success'] == true) {
        final perf = results[1].data['data'];
        topClasses = (perf['top_classes'] as List)
            .map((j) => ClassPerformanceModel.fromJson(j))
            .toList();
        leastClasses = (perf['least_classes'] as List)
            .map((j) => ClassPerformanceModel.fromJson(j))
            .toList();
      }

      // Upcoming
      if (results[2].data['success'] == true) {
        upcomingClasses = (results[2].data['data'] as List)
            .map((j) => UpcomingClassModel.fromJson(j))
            .toList();
      }
    } catch (e) {
      errorMessage = "Failed to load dashboard data";
      debugPrint("Dashboard fetch error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Export report ─────────────────────────────────────────
  Future<String?> exportReport({
    required ReportType type,
    required ReportFilter filter,
  }) async {
    isExporting = true;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final id   = user?["id"] as String?;
      if (id == null) throw Exception("User not found");

      // ── 1. Fetch report data ──────────────────────────────
      final path = switch (type) {
        ReportType.classes  => "/institute/reports/classes/$id",
        ReportType.students => "/institute/reports/students/$id",
        ReportType.tutors   => "/institute/reports/tutors/$id",
      };

      final response = await _dio.get(
        path,
        queryParameters: filter.toQueryParams(),
      );

      if (response.data['success'] != true) {
        throw Exception("Failed to fetch report data");
      }

      final List<Map<String, dynamic>> rows = (response.data['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (rows.isEmpty) return null; // signal empty to UI

      // ── 2. Build Excel ────────────────────────────────────
      final excel  = Excel.createExcel();
      final sheetName = switch (type) {
        ReportType.classes  => "Class Report",
        ReportType.students => "Student Report",
        ReportType.tutors   => "Tutor Report",
      };

      excel.rename('Sheet1', sheetName);
      final sheet = excel[sheetName];

      // Headers — bold style
      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromHexString('#185FA5'),
        fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      );

      final headers = rows.first.keys.toList();
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(
          headers[i].replaceAll('_', ' ').toUpperCase(),
        );
        cell.cellStyle = headerStyle;
      }

      // Data rows
      for (var r = 0; r < rows.length; r++) {
        final values = rows[r].values.toList();
        for (var c = 0; c < values.length; c++) {
          final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1),
          );
          final val = values[c];
          cell.value = val is num
              ? DoubleCellValue(val.toDouble())
              : TextCellValue(val?.toString() ?? '');
        }
      }

      // ── 3. Save file ──────────────────────────────────────
      final timestamp = DateTime.now()
          .toIso8601String()
          .substring(0, 10)
          .replaceAll('-', '_');
      final fileName = switch (type) {
        ReportType.classes  => "class_report_$timestamp.xlsx",
        ReportType.students => "student_report_$timestamp.xlsx",
        ReportType.tutors   => "tutor_report_$timestamp.xlsx",
      };

      // Request storage permission on Android
      if (Platform.isAndroid) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          throw Exception("Storage permission denied");
        }
      }

      final dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      if (!await dir.exists()) await dir.create(recursive: true);

      final filePath = '${dir.path}/$fileName';
      final fileBytes = excel.encode();
      if (fileBytes == null) throw Exception("Failed to encode Excel");

      await File(filePath).writeAsBytes(fileBytes);
      return filePath;
    } catch (e) {
      debugPrint("Export error: $e");
      rethrow;
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}