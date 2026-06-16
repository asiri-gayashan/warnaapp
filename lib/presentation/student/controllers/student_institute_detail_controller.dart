import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_institute_page_controller.dart';

class StudentInstituteDetailController extends ChangeNotifier {
  final StudentInstituteModel institute;

  StudentInstituteDetailController({required this.institute});

  bool isLoadingClasses = false;
  List<StudentClassModel> classes = [];

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchInstituteClasses() async {
    isLoadingClasses = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    classes = studentDummyClasses
        .where((c) => c.instituteId == institute.id)
        .toList();

    isLoadingClasses = false;
    notifyListeners();
  }
}
