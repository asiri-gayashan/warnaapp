class TutorMarkPaymentController {
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
  // Dummy existing payment records per class id (returned regardless of the
  // requested month/year, to keep this UI-only pass simple)
  // -----------------------------------------------------------------------
  final Map<String, List<Map<String, dynamic>>> _paymentsByClass = {
    '1': [
      {'id': 'pay-1', 'student_id': 'std-1', 'status': 'PAID'},
      {'id': 'pay-2', 'student_id': 'std-6', 'status': 'PAID'},
    ],
  };

  // GET enrolled students by class id (dummy)
  Future<List<Map<String, dynamic>>?> getEnrollStudentsByClassId(
    String classId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _enrolledStudentsByClass[classId] ?? [];
  }

  // GET payments by class id, month, year (dummy)
  Future<List<Map<String, dynamic>>?> getPaymentsByClassAndMonth(
    String classId,
    int month,
    int year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _paymentsByClass[classId] ?? [];
  }

  // POST — insert new payment records (dummy)
  Future<bool> insertPayments(List<Map<String, dynamic>> payments) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  // PATCH — update single payment status (dummy)
  Future<bool> updatePaymentStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // Get logged in user id (dummy)
  Future<String?> getMarkedUserId() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return 'tutor-user-1';
  }
}
