import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_mark_attendance_controller.dart';

class TutorMarkAttendancePage extends StatefulWidget {
  final String classId;
  final String className;

  const TutorMarkAttendancePage({
    Key? key,
    required this.classId,
    required this.className,
  }) : super(key: key);

  @override
  State<TutorMarkAttendancePage> createState() =>
      _TutorMarkAttendancePageState();
}

class _TutorMarkAttendancePageState extends State<TutorMarkAttendancePage> {
  final TutorMarkAttendanceController _controller =
      TutorMarkAttendanceController();
  final TextEditingController _searchController = TextEditingController();

  // Enrolled students from backend
  List<Map<String, dynamic>> _enrolledStudents = [];

  // Existing attendance records for selected date
  // key: student_id, value: {id, status}
  Map<String, Map<String, dynamic>> _existingAttendance = {};

  // Current attendance state being marked
  // key: student_id, value: 'PRESENT' or 'ABSENT'
  Map<String, String> _attendanceMap = {};

  bool _isLoading = true;
  bool _isSaving = false;
  DateTime _selectedDate = DateTime.now();

  String get _formattedDate =>
      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load enrolled students
    final students = await _controller.getEnrollStudentsByClassId(
      widget.classId,
    );

    // Load existing attendance for selected date
    final attendance = await _controller.getAttendanceByClassAndDate(
      widget.classId,
      _formattedDate,
    );

    final existingMap = <String, Map<String, dynamic>>{};
    final attendanceMap = <String, String>{};

    // Map existing attendance by student_id
    if (attendance != null) {
      for (final record in attendance) {
        final studentId = record['student_id']?.toString() ?? '';
        existingMap[studentId] = {
          'id': record['id'],
          'status': record['status'],
        };
        attendanceMap[studentId] = record['status'];
      }
    }

    // For students with no existing record, default to ABSENT
    if (students != null) {
      for (final student in students) {
        final studentId = student['student_id']?.toString() ?? '';
        if (!attendanceMap.containsKey(studentId)) {
          attendanceMap[studentId] = 'ABSENT';
        }
      }
    }

    setState(() {
      _enrolledStudents = students ?? [];
      _existingAttendance = existingMap;
      _attendanceMap = attendanceMap;
      _isLoading = false;
    });
  }

  // When date changes reload attendance for new date
  Future<void> _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDate = newDate;
      _isLoading = true;
    });

    final attendance = await _controller.getAttendanceByClassAndDate(
      widget.classId,
      "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}",
    );

    final existingMap = <String, Map<String, dynamic>>{};
    final attendanceMap = <String, String>{};

    if (attendance != null) {
      for (final record in attendance) {
        final studentId = record['student_id']?.toString() ?? '';
        existingMap[studentId] = {
          'id': record['id'],
          'status': record['status'],
        };
        attendanceMap[studentId] = record['status'];
      }
    }

    for (final student in _enrolledStudents) {
      final studentId = student['student_id']?.toString() ?? '';
      if (!attendanceMap.containsKey(studentId)) {
        attendanceMap[studentId] = 'ABSENT';
      }
    }

    setState(() {
      _existingAttendance = existingMap;
      _attendanceMap = attendanceMap;
      _isLoading = false;
    });
  }

  void _toggleAttendance(String studentId) {
    setState(() {
      final current = _attendanceMap[studentId] ?? 'ABSENT';
      _attendanceMap[studentId] = current == 'PRESENT' ? 'ABSENT' : 'PRESENT';
    });
  }

  void _toggleAll(bool markPresent) {
    setState(() {
      for (final student in _filteredStudents) {
        final studentId = student['student_id']?.toString() ?? '';
        _attendanceMap[studentId] = markPresent ? 'PRESENT' : 'ABSENT';
      }
    });
  }

  Future<void> _saveAttendance() async {
    setState(() => _isSaving = true);

    final markedUserId = await _controller.getMarkedUserId();

    if (markedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Could not get logged in user')),
            ],
          ),
        ),
      );

      setState(() => _isSaving = false);
      return;
    }

    bool allSuccess = true;

    // Separate into new records and updates
    final toInsert = <Map<String, dynamic>>[];
    final toUpdate = <Map<String, String>>[];

    for (final student in _enrolledStudents) {
      final studentId = student['student_id']?.toString() ?? '';
      final status = _attendanceMap[studentId] ?? 'ABSENT';
      final existing = _existingAttendance[studentId];

      if (existing != null) {
        // Only update if status changed
        if (existing['status'] != status) {
          toUpdate.add({'id': existing['id'], 'status': status});
        }
      } else {
        // New record
        toInsert.add({
          'class_id': widget.classId,
          'student_id': studentId,
          'status': status,
          'marked_user_id': markedUserId,
        });
      }
    }

    // Insert new records
    if (toInsert.isNotEmpty) {
      final success = await _controller.insertAttendance(toInsert);
      if (!success) allSuccess = false;
    }

    // Update changed records
    for (final update in toUpdate) {
      final success = await _controller.updateAttendanceStatus(
        update['id']!,
        update['status']!,
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
              Expanded(child: Text('Attendance saved successfully')),
            ],
          ),
        ),
      );

      // Reload to sync fresh data
      await _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Some records failed to save')),
            ],
          ),
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != _selectedDate) {
      await _onDateChanged(picked);
    }
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchController.text.isEmpty) return _enrolledStudents;
    return _enrolledStudents.where((s) {
      final name = (s['student_full_name'] ?? '').toLowerCase();
      return name.contains(_searchController.text.toLowerCase());
    }).toList();
  }

  int get _presentCount =>
      _attendanceMap.values.where((s) => s == 'PRESENT').length;

  int get _absentCount =>
      _attendanceMap.values.where((s) => s == 'ABSENT').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mark Attendance',
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
                  _buildHeaderCard(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildSelectAllRow(),
                  const SizedBox(height: 12),
                  _buildTable(),
                  const SizedBox(height: 24),
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
            'You are marking attendance for:',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 12),

          // Class name
          _buildHeaderChip(Icons.class_, widget.className),
          const SizedBox(height: 10),

          // Date picker
          GestureDetector(
            onTap: _pickDate,
            child: _buildHeaderChip(
              Icons.calendar_today,
              _formattedDate,
              trailing: const Icon(Icons.edit, color: Colors.white70, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String label, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          'Total',
          '${_enrolledStudents.length}',
          Icons.people_alt,
          AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Present',
          '$_presentCount',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(width: 12),
        _buildStatCard('Absent', '$_absentCount', Icons.cancel, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => setState(() {
                    _searchController.clear();
                  }),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildSelectAllRow() {
    final allPresent =
        _filteredStudents.isNotEmpty &&
        _filteredStudents.every(
          (s) => _attendanceMap[s['student_id']?.toString()] == 'PRESENT',
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Students (${_filteredStudents.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            const Text(
              'Mark All Present',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _toggleAll(!allPresent),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: allPresent ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: allPresent
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    width: 1.5,
                  ),
                ),
                child: allPresent
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable() {
    if (_filteredStudents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No students found',
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
            // Header
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
                  SizedBox(width: 40),
                ],
              ),
            ),

            // Rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                final studentId = student['student_id']?.toString() ?? '';
                final status = _attendanceMap[studentId] ?? 'ABSENT';
                final isPresent = status == 'PRESENT';
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
                        child: Text(
                          student['student_full_name'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Grade
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Grade ${student['student_grade'] ?? ''}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      // Status badge
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isPresent ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPresent ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isPresent ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Toggle checkbox
                      SizedBox(
                        width: 40,
                        child: GestureDetector(
                          onTap: () => _toggleAttendance(studentId),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isPresent
                                    ? Colors.green
                                    : AppColors.textSecondary,
                                width: 1.5,
                              ),
                            ),
                            child: isPresent
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !_isSaving ? _saveAttendance : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
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
                'Save Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
