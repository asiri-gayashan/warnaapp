import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_enroll_students_controller.dart';
import 'package:warna_app/shared/widgets/modals/student_search_dialog.dart';

class TutorEnrollStudentPage extends StatefulWidget {
  final String classId;
  final String className;

  const TutorEnrollStudentPage({
    Key? key,
    required this.classId,
    required this.className,
  }) : super(key: key);

  @override
  State<TutorEnrollStudentPage> createState() =>
      _TutorEnrollStudentPageState();
}

class _TutorEnrollStudentPageState extends State<TutorEnrollStudentPage> {
  final TutorEnrollStudentsController _controller =
      TutorEnrollStudentsController();

  // Students already enrolled
  List<Map<String, dynamic>> _enrolledStudents = [];

  // Newly added students (not yet saved) — temporary list
  List<Map<String, dynamic>> _pendingStudents = [];

  // Track status changes for existing enrolled students
  // key: enrollment id, value: new status
  Map<String, String> _statusChanges = {};

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    setState(() => _isLoading = true);

    final data = await _controller.getEnrollStudentsByClassId(widget.classId);

    setState(() {
      _enrolledStudents = data ?? [];
      _isLoading = false;
    });
  }

  // Called when user selects a student from search dialog
  void _onStudentSelected(Map<String, dynamic> student) {
    final studentId = student['users']['id']?.toString();
    final studentEmail = student['users']['email']?.toString();
    final studentName =
        student['users']['full_name']?.toString() ?? studentEmail ?? '';
    final studentPhone = student['users']['phone']?.toString() ?? '';
    final studentGrade = student['student']?['grade']?.toString() ?? '';

    // Check if already in enrolled list
    final alreadyEnrolled = _enrolledStudents.any(
      (e) => e['student_id'] == studentId,
    );

    // Check if already in pending list
    final alreadyPending = _pendingStudents.any(
      (e) => e['student_id'] == studentId,
    );

    if (alreadyEnrolled || alreadyPending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.info,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Student already added')),
            ],
          ),
        ),
      );

      return;
    }

    setState(() {
      _pendingStudents.add({
        'student_id': studentId,
        'student_full_name': studentName,
        'student_phone': studentPhone,
        'student_grade': studentGrade,
        'status': 'ACTIVE',
        'isPending': true,
      });
    });

    _controller.clearSelectedStudent();
  }

  // Toggle status of existing enrolled student
  void _toggleExistingStatus(Map<String, dynamic> enrollment) {
    final id = enrollment['id'];
    final currentStatus = _statusChanges[id] ?? enrollment['status'];
    final newStatus = currentStatus == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';

    setState(() {
      _statusChanges[id] = newStatus;
    });
  }

  // Toggle status of pending student
  void _togglePendingStatus(int index) {
    setState(() {
      final current = _pendingStudents[index]['status'];
      _pendingStudents[index]['status'] = current == 'ACTIVE'
          ? 'INACTIVE'
          : 'ACTIVE';
    });
  }

  // Remove pending student before saving
  void _removePending(int index) {
    setState(() {
      _pendingStudents.removeAt(index);
    });
  }

  Future<void> _saveEnrollments() async {
    setState(() => _isSaving = true);

    bool allSuccess = true;

    // 1. Save new pending enrollments
    if (_pendingStudents.isNotEmpty) {
      final toCreate = _pendingStudents
          .map(
            (s) => {
              'class_id': widget.classId,
              'student_id': s['student_id'],
              'status': s['status'],
            },
          )
          .toList();

      final success = await _controller.createEnrollStudents(toCreate);
      if (!success) allSuccess = false;
    }

    // 2. Save status changes for existing enrollments
    for (final entry in _statusChanges.entries) {
      final success = await _controller.updateEnrollmentStatus(
        entry.key,
        entry.value,
      );
      if (!success) allSuccess = false;
    }

    if (allSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.success,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Enrollments saved successfully')),
            ],
          ),
        ),
      );

      // Reload fresh data
      _statusChanges.clear();
      _pendingStudents.clear();
      await _loadEnrollments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.success,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Some enrollments failed to save')),
            ],
          ),
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Enroll Students',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  _buildHeaderCard(),

                  const SizedBox(height: 24),

                  // Table
                  _buildTable(),

                  const SizedBox(height: 20),

                  // Save button
                  _buildSaveButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are enrolling students for:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Class name chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.class_, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.className,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Student search picker
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => StudentSearchDialog(
                onSearch: (email) async {
                  return await _controller.searchStudentByEmail(email);
                },
                onStudentSelected: (student) {
                  // NO Navigator.pop here — let the dialog close itself
                  _onStudentSelected(student);
                },
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add student by email',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const Icon(
                    Icons.person_add_alt_1,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final allRows = [..._enrolledStudents, ..._pendingStudents];

    if (allRows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No students enrolled yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: AppColors.primary.withOpacity(0.06),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Grade',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(width: 32),
                ],
              ),
            ),

            // Table rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allRows.length,
              itemBuilder: (context, index) {
                final isPending = index >= _enrolledStudents.length;
                final pendingIndex = isPending
                    ? index - _enrolledStudents.length
                    : -1;
                final row = allRows[index];

                final status = isPending
                    ? row['status']
                    : (_statusChanges[row['id']] ?? row['status']);

                final isActive = status == 'ACTIVE';
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  color: isEven
                      ? Colors.white
                      : AppColors.background.withOpacity(0.4),
                  child: Row(
                    children: [
                      // Name
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            if (isPending)
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '◉',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                row['student_full_name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Grade
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Grade ${row['student_grade'] ?? ''}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      // Status toggle
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            if (isPending) {
                              _togglePendingStatus(pendingIndex);
                            } else {
                              _toggleExistingStatus(row);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isActive ? 'ACTIVE' : 'INACTIVE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.green : Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      // Remove pending row button
                      SizedBox(
                        width: 32,
                        child: isPending
                            ? GestureDetector(
                                onTap: () => _removePending(pendingIndex),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.red,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final hasChanges = _pendingStudents.isNotEmpty || _statusChanges.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasChanges && !_isSaving ? _saveEnrollments : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Enrollments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
