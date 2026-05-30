import 'package:flutter/material.dart';
import 'package:warna_app/core/network/dio_client.dart';
import 'package:warna_app/core/utils/user_service.dart';

import 'package:warna_app/data/models/class_model.dart';
import 'package:warna_app/presentation/institute/controllers/tutor_page_controller.dart';

class TutorDetailController extends ChangeNotifier {
  final _dio = DioClient.instance;

  final TutorModel tutor;

  TutorDetailController({required this.tutor});

  List<ClassModel> _classes = [];
  List<ClassModel> get classes => _classes;

  bool isLoadingClasses = false;
  String? errorMessage;

  // ── Fetch classes for this tutor at the institute ─────────────
  Future<void> fetchTutorClasses() async {
    isLoadingClasses = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await UserService.getUser();
      final instituteUserId = user?["id"];

      // classes.tutor_id = users.id, so we pass tutor.userId (users.id)
      final response = await _dio.get(
        "/classes/tutor/${tutor.userId}/institute/$instituteUserId",
      );

      debugPrint("Fetch Tutor Classes Response: ${response.data}");

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        _classes = data
            .map((json) => ClassModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _classes = [];
      }
    } catch (e) {
      debugPrint("Error fetching tutor classes: $e");
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