import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_institute_page_controller.dart';

class StudentInstituteDetailController extends ChangeNotifier {
  final _dio = DioClient.instance;
  final StudentInstituteModel institute;

  StudentInstituteDetailController({required this.institute});

  bool isLoadingClasses = false;
  String? errorMessage;
  List<StudentClassModel> classes = [];

  // ── Fetch student's classes at this institute ─────────────────
  Future<void> fetchInstituteClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final response =
          await _dio.get('/student-dashboard/classes/$studentUserId');
      final List<dynamic> raw = response.data is List
          ? List<dynamic>.from(response.data as List)
          : List<dynamic>.from((response.data['data'] as List?) ?? []);
      final all = raw
          .map((j) => StudentClassModel.fromJson(j as Map<String, dynamic>))
          .toList();
      // Filter to classes at this institute
      classes = all.where((c) => c.instituteId == institute.id).toList();
    } catch (e) {
      debugPrint('Error fetching institute classes: $e');
      errorMessage = 'Failed to load classes';
      classes = [];
    }
    isLoadingClasses = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
