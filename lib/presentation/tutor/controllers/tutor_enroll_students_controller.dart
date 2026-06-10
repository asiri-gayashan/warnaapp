import 'package:flutter/material.dart';

class TutorEnrollStudentsController extends ChangeNotifier {
  // -----------------------------------------------------------------------
  // Dummy enrolled students per class id
  // -----------------------------------------------------------------------
  final Map<String, List<Map<String, dynamic>>> _enrollmentsByClass = {
    '1': [
      {
        'id': 'enr-1',
        'student_id': 'std-1',
        'student_full_name': 'Nimal Perera',
        'student_phone': '+94 71 234 5678',
        'student_grade': '12',
        'status': 'ACTIVE',
      },
      {
        'id': 'enr-2',
        'student_id': 'std-2',
        'student_full_name': 'Kavindi Silva',
        'student_phone': '+94 77 345 6789',
        'student_grade': '12',
        'status': 'ACTIVE',
      },
    ],
    '2': [
      {
        'id': 'enr-3',
        'student_id': 'std-3',
        'student_full_name': 'Tharindu Fernando',
        'student_phone': '+94 76 456 7890',
        'student_grade': '11',
        'status': 'ACTIVE',
      },
    ],
  };

  /// SEARCH STUDENT BY EMAIL (dummy)
  Future<Map<String, dynamic>?> searchStudentByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.trim().isEmpty) {
      return {"status": false, "message": "Student not found"};
    }

    return {
      "status": true,
      "data": {
        "users": {
          "id": "std-${DateTime.now().millisecondsSinceEpoch}",
          "full_name": "Sahan Jayasuriya",
          "email": email,
          "phone": "+94 70 987 6543",
        },
        "student": {"grade": "10"},
      },
    };
  }

  /// GET ENROLL STUDENTS BY CLASS ID (dummy)
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
    String classId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _enrollmentsByClass[classId] ?? [];
  }

  /// CREATE ENROLL STUDENTS (dummy)
  Future<bool> createEnrollStudents(
    List<Map<String, dynamic>> enrollments,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  /// UPDATE ENROLLMENT STATUS (dummy)
  Future<bool> updateEnrollmentStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  /// SELECTED STUDENT
  String? _selectedStudent;
  String? get selectedStudent => _selectedStudent;

  /// SELECTED STUDENT EMAIL
  String? _selectedStudentEmail;
  String? get selectedStudentEmail => _selectedStudentEmail;

  /// VALIDATION
  bool _studentValidated = false;
  bool get studentValidated => _studentValidated;

  /// ERROR
  String? _studentError;
  String? get studentError => _studentError;

  /// SET STUDENT
  void setStudentWithName(String? id, String? email) {
    _selectedStudent = id;
    _selectedStudentEmail = email;

    if (id == null || id.isEmpty) {
      _studentValidated = false;
      _studentError = "Please select a student";
    } else {
      _studentValidated = true;
      _studentError = null;
    }

    notifyListeners();
  }

  /// CLEAR SELECTED STUDENT
  void clearSelectedStudent() {
    _selectedStudent = null;
    _selectedStudentEmail = null;
    _studentValidated = false;
    _studentError = null;
    notifyListeners();
  }
}
