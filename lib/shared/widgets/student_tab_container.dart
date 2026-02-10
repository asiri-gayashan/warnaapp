import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StudentTabContainer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const StudentTabContainer({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_filled,
                label: '',
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.class_outlined,
                activeIcon: Icons.class_,
                label: '',
              ),
              _buildTabItem(
                index: 2,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: '',
              ),
              _buildTabItem(
                index: 3,
                icon: Icons.payments_outlined,
                activeIcon: Icons.payments,
                label: '',
              ),
              _buildTabItem(
                index: 4,
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications,
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textDisabled,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}