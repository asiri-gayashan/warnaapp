import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';



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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                index: 0,
                icon: CupertinoIcons.home,
                activeIcon: CupertinoIcons.house_fill,
                label: 'Home',
              ),
              _buildTabItem(
                index: 1,
                icon: CupertinoIcons.book,
                activeIcon: CupertinoIcons.book_fill,
                label: 'Classes',
              ),
              _buildTabItem(
                index: 2,
                icon: CupertinoIcons.bell,
                activeIcon: CupertinoIcons.bell_fill,
                label: 'Notifications',
              ),
              _buildTabItem(
                index: 3,
                icon: CupertinoIcons.creditcard,
                activeIcon: CupertinoIcons.creditcard_fill,
                label: 'Records',
              ),

              _buildTabItem(
                index: 4,
                icon: CupertinoIcons.person,
                activeIcon: CupertinoIcons.person_fill,
                label: 'Profile',
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
              color: isActive ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}