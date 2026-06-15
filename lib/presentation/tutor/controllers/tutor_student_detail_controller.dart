import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_student_page_controller.dart';

class TutorStudentDetailController extends ChangeNotifier {
  final _dio = DioClient.instance;

  final TutorStudentModel student;

  TutorStudentDetailController({required this.student});

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoadingClasses = false;
  String? errorMessage;

  // ── Fetch classes this student is enrolled in (tutor's classes only) ──
  Future<void> fetchStudentClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final tutorUserId = user?["id"];

      // student.userId is users.id — matches class_students.student_id
      final response = await _dio.get(
        "/classes/students/${student.userId}/tutor/$tutorUserId",
      );

      if (response.data['success'] == true &&
          response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        _classes = data
            .map((json) =>
                ClassModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _classes = [];
      }
    } catch (e) {
      debugPrint("Error fetching student classes: $e");
      errorMessage = "Failed to load classes";
      _classes = [];
    } finally {
      isLoadingClasses = false;
      notifyListeners();
    }
  }

  // ── Day number → name ─────────────────────────────────────────
  String dayName(int day) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return (day >= 0 && day < days.length) ? days[day] : 'Unknown';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
