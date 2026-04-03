import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StudentPaymentOverviewCard extends StatelessWidget {
  const StudentPaymentOverviewCard({
    Key? key,
    required this.paidStudents,
    required this.nonPaidStudents,
  }) : super(key: key);

  final int paidStudents;
  final int nonPaidStudents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payments,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPaymentStat(
                  label: 'Paid Students',
                  value: paidStudents.toString(),
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey.shade300),
              Expanded(
                child: _buildPaymentStat(
                  label: 'Non-paid Students',
                  value: nonPaidStudents.toString(),
                  color: Colors.red,
                  icon: Icons.cancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStat({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
