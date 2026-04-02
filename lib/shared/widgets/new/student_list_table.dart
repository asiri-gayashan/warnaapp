import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StudentListTable extends StatelessWidget {
  final List<Map<String, dynamic>> paginatedStudents;

  const StudentListTable({
    Key? key,
    required this.paginatedStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(14),
              color: AppColors.primary.withOpacity(0.04),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Roll No', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('Student Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Mobile', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),

            // Table Body
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paginatedStudents.length,
              itemBuilder: (context, index) {
                final student = paginatedStudents[index];
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.all(14),
                  color: isEven ? Colors.white : AppColors.background.withOpacity(0.3),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          student['rollNo'] ?? '',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          student['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: const [
                            Text(
                              "0768645011", // Dummy static number as in original
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
}
