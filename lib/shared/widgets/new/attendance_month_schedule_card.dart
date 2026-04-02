import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AttendanceMonthScheduleCard extends StatelessWidget {
  final String monthYear;
  final int totalClasses;
  final List<Map<String, dynamic>> marchDays;

  const AttendanceMonthScheduleCard({
    Key? key,
    required this.monthYear,
    required this.totalClasses,
    required this.marchDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYear,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalClasses Classes',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: marchDays.map((day) {
              Color bgColor;
              Color textColor;
              IconData? icon;

              switch (day['status']) {
                case 'completed':
                  bgColor = AppColors.success.withOpacity(0.1);
                  textColor = AppColors.success;
                  icon = Icons.check;
                  break;
                case 'today':
                  bgColor = AppColors.primary.withOpacity(0.1);
                  textColor = AppColors.primary;
                  icon = Icons.circle;
                  break;
                default:
                  bgColor = Colors.grey.shade50;
                  textColor = AppColors.textSecondary;
                  icon = null;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: textColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day['date'] ?? '',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 4),
                      Icon(icon, size: 12, color: textColor),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem(AppColors.success, 'Completed'),
              const SizedBox(width: 12),
              _buildLegendItem(AppColors.primary, 'Today'),
              const SizedBox(width: 12),
              _buildLegendItem(AppColors.textSecondary, 'Upcoming'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
