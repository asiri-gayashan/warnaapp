import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_tutor_detail_controller.dart';
import 'package:warna_app/presentation/student/controllers/student_tutor_page_controller.dart';
import 'package:warna_app/presentation/student/screens/classes/student_class_detail_page.dart';
import 'package:warna_app/shared/widgets/new/info_tile.dart';
import 'package:warna_app/shared/widgets/new/stat_column.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

class StudentTutorDetailPage extends StatefulWidget {
  final StudentTutorModel tutor;

  const StudentTutorDetailPage({Key? key, required this.tutor})
      : super(key: key);

  @override
  State<StudentTutorDetailPage> createState() =>
      _StudentTutorDetailPageState();
}

class _StudentTutorDetailPageState extends State<StudentTutorDetailPage> {
  late StudentTutorDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StudentTutorDetailController(tutor: widget.tutor);
    _controller.fetchTutorClasses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutor = _controller.tutor;

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
              'Tutor Details',
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
                          tutor.fullName.isNotEmpty
                              ? tutor.fullName[0].toUpperCase()
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
                        tutor.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tutor.email,
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
                      StatColumn(
                        label: 'My Classes',
                        value: '${_controller.classes.length}',
                      ),
                      StatColumn(
                        label: 'Subject',
                        value: tutor.subjects.isNotEmpty
                            ? tutor.subjects.first
                            : '—',
                      ),
                      StatColumn(
                        label: 'Experience',
                        value: '${tutor.experience} yrs',
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
                  tutor.description.isNotEmpty
                      ? tutor.description
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
                  value: tutor.email,
                ),
                InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Mobile',
                  value: tutor.phone,
                ),

                const SizedBox(height: 24),

                // ── Professional Information ────────────────────
                const Text(
                  'Professional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'District',
                  value: tutor.districtName,
                ),
                InfoTile(
                  icon: Icons.menu_book_outlined,
                  label: 'Subject(s)',
                  value: tutor.subjects.join(', '),
                ),
                InfoTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Experience',
                  value: '${tutor.experience} years',
                ),

                const SizedBox(height: 24),

                // ── Classes with this Tutor ─────────────────────
                const Text(
                  'Classes with this Tutor',
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
                                  'No classes with this tutor',
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
                                      '${cls.startTime} - ${cls.endTime}',
                                  teacher: cls.tutorName,
                                  day: studentDayName(cls.day),
                                  iconColor: AppColors.secondary,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StudentClassDetailPage(
                                        classItemDetails: cls,
                                      ),
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
