import 'package:flutter/material.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_tutor_page_controller.dart';

class StudentTutorDetailController extends ChangeNotifier {
  final StudentTutorModel tutor;

  StudentTutorDetailController({required this.tutor});

  bool isLoadingClasses = false;
  List<StudentClassModel> classes = [];

  // ── Fetch (dummy) ────────────────────────────────────────────
  Future<void> fetchTutorClasses() async {
    isLoadingClasses = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    classes =
        studentDummyClasses.where((c) => c.tutorId == tutor.id).toList();

    isLoadingClasses = false;
    notifyListeners();
  }
}
