class TutorMarkAttendanceController {
  // -----------------------------------------------------------------------
  // Dummy enrolled students per class id
  // -----------------------------------------------------------------------
  final Map<String, List<Map<String, dynamic>>> _enrolledStudentsByClass = {
    '1': [
      {
        'student_id': 'std-1',
        'student_full_name': 'Nimal Perera',
        'student_grade': '12',
      },
      {
        'student_id': 'std-2',
        'student_full_name': 'Kavindi Silva',
        'student_grade': '12',
      },
      {
        'student_id': 'std-6',
        'student_full_name': 'Ruwan Bandara',
        'student_grade': '12',
      },
      {
        'student_id': 'std-8',
        'student_full_name': 'Chamara Silva',
        'student_grade': '12',
      },
    ],
    '2': [
      {
        'student_id': 'std-3',
        'student_full_name': 'Tharindu Fernando',
        'student_grade': '11',
      },
      {
        'student_id': 'std-4',
        'student_full_name': 'Sahan Jayasuriya',
        'student_grade': '11',
      },
    ],
  };

  // -----------------------------------------------------------------------
  // Dummy existing attendance records per class id (returned regardless of
  // the requested date, to keep this UI-only pass simple)
  // -----------------------------------------------------------------------
  final Map<String, List<Map<String, dynamic>>> _attendanceByClass = {
    '1': [
      {'id': 'att-1', 'student_id': 'std-1', 'status': 'PRESENT'},
      {'id': 'att-2', 'student_id': 'std-2', 'status': 'ABSENT'},
    ],
  };

  // GET enrolled students by class id (dummy)
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
    String classId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _enrolledStudentsByClass[classId] ?? [];
  }

  // GET attendance by class id and date (dummy)
  Future<List<Map<String, dynamic>>?> getAttendanceByClassAndDate(
    String classId,
    String date,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _attendanceByClass[classId] ?? [];
  }

  // POST — insert new attendance records (dummy)
  Future<bool> insertAttendance(List<Map<String, dynamic>> records) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  // PATCH — update single attendance record status (dummy)
  Future<bool> updateAttendanceStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // Get logged in user id (dummy)
  Future<String?> getMarkedUserId() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return 'tutor-user-1';
  }
}
