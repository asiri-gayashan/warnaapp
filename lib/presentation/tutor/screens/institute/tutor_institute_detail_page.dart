import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_institute_detail_controller.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_institute_page_controller.dart';
import 'package:warna_app/presentation/tutor/screens/classes/tutor_class_detail_page.dart';
import 'package:warna_app/shared/widgets/new/info_tile.dart';
import 'package:warna_app/shared/widgets/new/stat_column.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

class TutorInstituteDetailPage extends StatefulWidget {
  final TutorInstituteModel institute;

  const TutorInstituteDetailPage({Key? key, required this.institute})
    : super(key: key);

  @override
  State<TutorInstituteDetailPage> createState() =>
      _TutorInstituteDetailPageState();
}

class _TutorInstituteDetailPageState extends State<TutorInstituteDetailPage> {
  late TutorInstituteDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TutorInstituteDetailController(institute: widget.institute);
    _controller.fetchInstituteClasses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final institute = widget.institute;

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
              'Institute Details',
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
                          institute.fullName.isNotEmpty
                              ? institute.fullName[0].toUpperCase()
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
                        institute.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        institute.email,
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
                        label: 'Total Tutors',
                        value: '${institute.totalTutors}',
                      ),
                      StatColumn(
                        label: 'Total Students',
                        value: '${institute.totalStudents}',
                      ),
                      StatColumn(
                        label: 'Total Classes',
                        value: '${institute.totalClasses}',
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
                  institute.description.isNotEmpty
                      ? institute.description
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
                  value: institute.email,
                ),
                InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Mobile',
                  value: institute.phone,
                ),

                const SizedBox(height: 24),

                // ── Location Information ─────────────────────────
                const Text(
                  'Location Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'District',
                  value: institute.districtName,
                ),
                InfoTile(
                  icon: Icons.home_outlined,
                  label: 'Address',
                  value: institute.addressLine1.isNotEmpty
                      ? '${institute.addressLine1}${institute.addressLine2.isNotEmpty ? ', ${institute.addressLine2}' : ''}'
                      : 'N/A',
                ),

                const SizedBox(height: 24),

                // ── My Classes at this Institute ────────────────
                const Text(
                  'My Class Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                InfoTile(
                  icon: Icons.sailing,
                  label: 'My Classes',
                  value: '${institute.myClassCount.toString()} Classes',
                ),
                InfoTile(
                  icon: Icons.people,
                  label: 'My Students',
                  value: '${institute.myStudentCount.toString()} Students',
                ),

                const SizedBox(height: 24),

                const Text(
                  'My Classes In Institute',
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
                              'No classes at this institute yet',
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
                                  builder: (context) => TutorClassDetailPage(
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
