import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EnrollmentListHeader extends StatelessWidget {
  final bool hasStudents;
  final bool selectAll;
  final VoidCallback onToggleAll;

  const EnrollmentListHeader({
    Key? key,
    required this.hasStudents,
    required this.selectAll,
    required this.onToggleAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Student List',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (hasStudents)
          Row(
            children: [
              const Text(
                'Select All',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggleAll,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selectAll ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: selectAll ? AppColors.primary : AppColors.textDisabled,
                      width: 1.5,
                    ),
                  ),
                  child: selectAll
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
