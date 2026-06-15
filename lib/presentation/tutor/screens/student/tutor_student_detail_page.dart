import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_student_detail_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_student_page_controller.dart';
import 'package:warna_app/presentation/tutor/screens/classes/tutor_class_detail_page.dart';
import 'package:warna_app/shared/widgets/new/info_tile.dart';
import 'package:warna_app/shared/widgets/new/stat_column.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

class TutorStudentDetailPage extends StatefulWidget {
  final Map<String, dynamic> student;

  const TutorStudentDetailPage({Key? key, required this.student})
    : super(key: key);

  @override
  State<TutorStudentDetailPage> createState() =>
      _TutorStudentDetailPageState();
}

class _TutorStudentDetailPageState extends State<TutorStudentDetailPage> {
  late TutorStudentDetailController _controller;

  @override
  void initState() {
    super.initState();
    // toMap() produces flat keys — fromJson expects the same flat shape
    // since TutorStudentModel.fromJson reads flat keys directly (no nesting
    // needed beyond 'users'). We normalise back to the API shape here.
    final studentModel = TutorStudentModel.fromJson(
      _normaliseMap(widget.student),
    );
    _controller = TutorStudentDetailController(student: studentModel);
    _controller.fetchStudentClasses();
  }

  /// Converts the flat toMap() output back into the shape
  Map<String, dynamic> _normaliseMap(Map<String, dynamic> m) {
    return {
      'id': m['id'],
      'user_id': m['user_id'],
      'dob': m['dob'],
      'age': m['age'],
      'school': m['school'],
      'grade': m['grade'],
      'created_at': m['created_at'],
      'users': {
        'full_name': m['full_name'],
        'email': m['email'],
        'phone': m['phone'],
        'address_line1': m['address_line1'],
        'address_line2': m['address_line2'],
        'description': m['description'],
        'district_id': m['district_id'],
        'status': m['status'],
        'role': m['role'],
        'district': {'name': m['district_name']},
      },
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = _controller.student;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Student Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Header ──────────────────────────────
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          student.fullName.isNotEmpty
                              ? student.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.email,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Quick Stats ─────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatColumn(label: 'Grade', value: '${student.grade}'),
                      StatColumn(label: 'Age', value: '${student.age} Years'),
                      StatColumn(
                        label: 'Classes',
                        value: '${_controller.classes.length}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Description ─────────────────────────────────
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  student.description.isNotEmpty
                      ? student.description
                      : 'No description available.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Contact Information ─────────────────────────
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: student.email,
                ),
                InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Mobile',
                  value: student.phone,
                ),

                const SizedBox(height: 24),

                // ── Personal Information ────────────────────────
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: '${student.age} years',
                ),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'District',
                  value: student.districtName,
                ),
                InfoTile(
                  icon: Icons.home_outlined,
                  label: 'Address',
                  value: student.addressLine1.isNotEmpty
                      ? student.addressLine1
                      : 'N/A',
                ),
                InfoTile(
                  icon: Icons.school_outlined,
                  label: 'School',
                  value: student.school.isNotEmpty ? student.school : 'N/A',
                ),

                const SizedBox(height: 24),

                // ── Enrolled Classes ────────────────────────────
                const Text(
                  'Enrolled Classes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                _controller.isLoadingClasses
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _controller.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _controller.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    : _controller.classes.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F7FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.class_outlined,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No enrolled classes',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: _controller.classes.map((cls) {
                            return UpcomingClassListTile(
                              className: cls.name,
                              grade: 'Grade ${cls.grade}',
                              time:
                                  '${cls.startTime.substring(0, 5)} - ${cls.endTime.substring(0, 5)}',
                              teacher: cls.tutorName,
                              day: _controller.dayName(cls.day),
                              iconColor: AppColors.secondary,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TutorClassDetailPage(classItemDetails: cls),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
