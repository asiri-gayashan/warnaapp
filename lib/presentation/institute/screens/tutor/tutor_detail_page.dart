import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/institute/controllers/tutor_detail_controller.dart';
import 'package:warna_app/presentation/institute/controllers/tutor_page_controller.dart';
import 'package:warna_app/shared/widgets/new/info_tile.dart';
import 'package:warna_app/shared/widgets/new/stat_column.dart';
import 'package:warna_app/presentation/institute/screens/classes/class_detail_page.dart';

import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

class TutorDetailPage extends StatefulWidget {
  final Map<String, dynamic> tutor;

  const TutorDetailPage({Key? key, required this.tutor}) : super(key: key);

  @override
  State<TutorDetailPage> createState() => _TutorDetailPageState();
}

class _TutorDetailPageState extends State<TutorDetailPage> {
  late TutorDetailController _controller;

  @override
  void initState() {
    super.initState();
    // Re-hydrate a TutorModel from the map passed by the list page
    final tutorModel = TutorModel.fromJson(_normaliseMap(widget.tutor));
    _controller = TutorDetailController(tutor: tutorModel);
    _controller.fetchTutorClasses();
  }

  /// The list page calls tutor.toMap() which uses flat keys (full_name, etc.)
  /// but TutorModel.fromJson expects the nested API shape. This adapter
  /// converts the flat map back into the API shape so fromJson works correctly.
  Map<String, dynamic> _normaliseMap(Map<String, dynamic> m) {
    return {
      'id': m['id'],
      'user_id': m['user_id'],
      'subject_id': m['subject_id'],
      'is_independent': m['is_independent'],
      'ratings': m['ratings'],
      'qualifications': m['qualifications'],
      'created_at': m['created_at'],
      'student_count': m['student_count'],
      'class_count': m['class_count'],
      'experience': m['experience'],
      'dob': m['dob'],
      'age': m['age'],
      'subject': {'id': m['subject_id'], 'name': m['subject_name']},
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
        'district': {'id': m['district_id'], 'name': m['district_name']},
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
              'Institute Tutor Details',
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
                // ── Profile Header ────────────────────────────────
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
                      const SizedBox(height: 6),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Quick Stats ───────────────────────────────────
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
                        label: 'Experience',
                        value: '${tutor.experience} Years',
                      ),
                      StatColumn(
                        label: 'Classes',
                        value: '${tutor.classCount}',
                      ),
                      StatColumn(
                        label: 'Students',
                        value: '${tutor.studentCount}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Description ───────────────────────────────────
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

                // ── Contact Information ───────────────────────────
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

                // ── Personal Information ──────────────────────────
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Age',
                  value: '${tutor.age} years',
                ),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'District',
                  value: tutor.districtName.isNotEmpty
                      ? tutor.districtName
                      : 'N/A',
                ),
                InfoTile(
                  icon: Icons.home_outlined,
                  label: 'Address',
                  value: tutor.addressLine1.isNotEmpty
                      ? tutor.addressLine1
                      : 'N/A',
                ),

                const SizedBox(height: 24),

                // ── Professional Information ──────────────────────
                const Text(
                  'Professional Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.menu_book_outlined,
                  label: 'Subject',
                  value: tutor.subjectName.isNotEmpty
                      ? tutor.subjectName
                      : 'N/A',
                ),
                InfoTile(
                  icon: Icons.star_outline,
                  label: 'Rating',
                  value: tutor.ratings != null
                      ? tutor.ratings.toString()
                      : 'Not rated',
                ),

                const SizedBox(height: 24),

                // ── Assigned Classes ──────────────────────────────
                const Text(
                  'Assigned Classes',
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
                              'No classes assigned',
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
                              time: '${cls.startTime} - ${cls.endTime}',
                              teacher: cls.tutorName,
                              day: _controller.dayName(cls.day),
                              iconColor: AppColors.secondary,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ClassDetailPage(classItemDetails: cls),
                                  ),
                                );
                              },
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

// ── Status Badge ──────────────────────────────────────────────────────────────
