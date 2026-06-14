import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_class_page_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_institute_page_controller.dart';

class TutorInstituteDetailController extends ChangeNotifier {
  final _dio = DioClient.instance;

  final TutorInstituteModel institute;

  TutorInstituteDetailController({required this.institute});

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoadingClasses = false;
  String? errorMessage;

  // ── Fetch the tutor's classes at this institute ───────────────
  Future<void> fetchInstituteClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final tutorUserId = user?["id"];

      // institute.id = users.id of the institute (matches classes.institute_id)
      final response = await _dio.get(
        "/classes/tutor/$tutorUserId/institute/${institute.id}",
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        _classes = data
            .map((json) => ClassModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _classes = [];
      }
    } catch (e) {
      debugPrint("Error fetching institute classes: $e");
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
