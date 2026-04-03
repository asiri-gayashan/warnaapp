import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';

class StatsOverviewRow extends StatelessWidget {
  final int totalStudents;
  final int presentCount;
  final int paidCount;

  const StatsOverviewRow({
    Key? key,
    required this.totalStudents,
    required this.presentCount,
    required this.paidCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Total Students',
            value: '$totalStudents',
            icon: Icons.people_alt,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: 'Paid',
            value: '$presentCount', // As originally mapped in the code
            icon: Icons.check_circle,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            label: 'Pending',
            value: '${totalStudents - paidCount}',
            icon: Icons.pending,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
