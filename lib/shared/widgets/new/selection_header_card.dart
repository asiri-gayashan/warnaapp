import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class SelectionHeaderCard extends StatelessWidget {
  final String title;
  final String classHint;
  final List<String> classes;
  final String? selectedClass;
  final ValueChanged<String?> onClassChanged;
  final String dateText;
  final IconData dateIcon;
  final VoidCallback onDateTap;

  const SelectionHeaderCard({
    Key? key,
    required this.title,
    required this.classHint,
    required this.classes,
    required this.selectedClass,
    required this.onClassChanged,
    required this.dateText,
    required this.dateIcon,
    required this.onDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  classHint,
                  style: const TextStyle(color: Colors.white70),
                ),
                value: selectedClass,
                dropdownColor: AppColors.primary,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                items: classes.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(
                      className,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: onClassChanged,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onDateTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    dateIcon,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
