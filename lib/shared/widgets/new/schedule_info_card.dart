import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ScheduleInfoCard extends StatelessWidget {
  const ScheduleInfoCard({
    Key? key,
    required this.day,
    required this.time,
    required this.duration,
  }) : super(key: key);

  final String day;
  final String time;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScheduleItem(
            icon: Icons.calendar_today,
            label: 'Day',
            value: day,
          ),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          _buildScheduleItem(
            icon: Icons.access_time,
            label: 'Time',
            value: time,
          ),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          _buildScheduleItem(
            icon: Icons.timer,
            label: 'Duration',
            value: duration,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
