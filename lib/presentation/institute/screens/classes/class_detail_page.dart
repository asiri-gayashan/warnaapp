import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/models/class_model.dart';
import 'package:warna_app/data/repositories/class_repository.dart';
import 'package:warna_app/presentation/institute/screens/classes/enroll_student_page.dart';
import 'package:warna_app/presentation/institute/screens/classes/institute_edit_class.dart';
import 'package:warna_app/shared/widgets/new/schedule_info_card.dart';
import 'package:warna_app/presentation/institute/screens/student/mark_payment_page.dart';
import 'package:warna_app/presentation/institute/screens/student/mark_attendance_page.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassModel classItemDetails;

  const ClassDetailPage({Key? key, required this.classItemDetails})
    : super(key: key);

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  ClassModel? classesData;
  bool isLoading = true;
  bool isReceived = false;

  @override
  void initState() {
    super.initState();
    loadClassData();
    
  }

  Future<void> loadClassData() async {
    final rawClassesData = await ClassRepository().getClassesById(
      widget.classItemDetails.id,
    );

    if (rawClassesData != null) {

      
      setState(() {
        classesData = ClassModel.fromJson(rawClassesData); 
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // classesData is from database, widget.classItemDetails is fallback only
    final classData = classesData!;

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
          'Institute Class Details ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnrollStudentPage(
                classId: classData.id,
                className: classData.name,
              ),
            ),
          ).then((_) {
            // This runs when user comes back from edit page
            setState(() {
              isLoading = true;
            });
            loadClassData();
          });
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classData.name.length > 21
                                  ? classData.name.substring(0, 22)
                                  : classData.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${classData.subjectName} • ${classData.tutorName}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.payments_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Monthly Fee',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rs. ${classData.amount.toString().split('.').first}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InstituteEditClassPage(
                                  classModel: classData,
                                ),
                              ),
                            ).then((_) {
                              // This runs when user comes back from edit page
                              setState(() {
                                isLoading = true;
                              });
                              loadClassData();
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Edit Class',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.sailing,
                        label:
                            SelectOptions.newgradesList.firstWhere(
                              (e) => e['id'] == classData.grade.toString(),
                            )['name'] ??
                            '',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.people,
                        label: '${classData.studentCount} Students',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.circle,
                        label: classData.status,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) =>
                      //             InstituteEditClassPage(classModel: classData),
                      //       ),
                      //     ).then((_) {
                      //       // This runs when user comes back from edit page
                      //       setState(() {
                      //         isLoading = true;
                      //       });
                      //       loadClassData();
                      //     });
                      //   },
                      //   child: _buildInfoChip(icon: Icons.edit, label: 'Edit'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Schedule Information
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ScheduleInfoCard(
              day:
                  SelectOptions.days.firstWhere(
                    (e) => e['id'] == classData.day.toString(),
                  )['name'] ??
                  '',
              time: classData.startTime.length >= 5
                  ? classData.startTime.substring(0, 5)
                  : classData.startTime,
              duration: classData.duration,
            ),

            const SizedBox(height: 24),


            // Tutor Payment Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classData.tutorName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tutor Payment Status',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isReceived
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isReceived ? Icons.check_circle : Icons.pending,
                          color: isReceived ? Colors.green : Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isReceived ? 'Paid' : 'Pending',
                          style: TextStyle(
                            color: isReceived ? Colors.green : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                classData.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarkAttendancePage(
                            className: classData.name,
                            classId: classData.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Mark Attendance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarkPaymentPage(
                            classId: classData.id,
                            className: classData.name,
                            classAmount: classData.amount,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Mark Payment'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fees & Attendance and Enroll Student Row

          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
