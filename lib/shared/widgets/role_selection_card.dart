import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RoleSelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.cardSelectedBorder
                : AppColors.cardBorder,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.cardSelectedBorder.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      letterSpacing: -0.3,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.cardSelectedBorder
                      : AppColors.cardBorder,
                  width: 2,
                ),
                color: isSelected ? AppColors.cardSelectedBorder : Colors.white,
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}