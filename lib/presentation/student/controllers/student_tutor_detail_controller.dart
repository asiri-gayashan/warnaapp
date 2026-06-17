import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_tutor_page_controller.dart';

class StudentTutorDetailController extends ChangeNotifier {
  final _dio = DioClient.instance;
  final StudentTutorModel tutor;

  StudentTutorDetailController({required this.tutor});

  bool isLoadingClasses = false;
  List<StudentClassModel> classes = [];

  // ── Fetch classes this student has with this tutor ────────────
  Future<void> fetchTutorClasses() async {
    isLoadingClasses = true;
    notifyListeners();
    try {
      final user = await UserService.getUser();
      final studentUserId = user?['id'];
      final response = await _dio.get('/student-dashboard/classes/$studentUserId');
      final List<dynamic> raw = response.data is List
          ? List<dynamic>.from(response.data as List)
          : List<dynamic>.from((response.data['data'] as List?) ?? []);
      final all = raw
          .map((j) => StudentClassModel.fromJson(j as Map<String, dynamic>))
          .toList();
      // Filter to classes taught by this tutor
      classes = all.where((c) => c.tutorId == tutor.userId).toList();
    } catch (e) {
      debugPrint('Error fetching tutor classes: $e');
      classes = [];
    }
    isLoadingClasses = false;
    notifyListeners();
  }
}
