import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';

class FinancialStatsRow extends StatelessWidget {
  final int totalStudents;
  final int paidCount;
  final num monthlyFee;

  const FinancialStatsRow({
    Key? key,
    required this.totalStudents,
    required this.paidCount,
    required this.monthlyFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final num totalReceivable = totalStudents * monthlyFee;
    final num totalReceived = paidCount * monthlyFee;
    final num totalPending = totalReceivable - totalReceived;

    return Row(
      children: [
        Expanded(
          child: _buildFinancialStatCard(
            title: 'Total Receivable',
            amount: 'Rs ${totalReceivable.toStringAsFixed(0)}',
            subAmount: 'Rs ${totalPending.toStringAsFixed(0)} pending',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFinancialStatCard(
            title: 'Received',
            amount: 'Rs ${totalReceived.toStringAsFixed(0)}',
            subAmount: '$paidCount/$totalStudents students',
            icon: Icons.payments_outlined,
            color: AppColors.success,
            backgroundColor: AppColors.success.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialStatCard({
    required String title,
    required String amount,
    required String subAmount,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subAmount,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
