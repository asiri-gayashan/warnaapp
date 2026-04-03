import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ClassSelectionCard extends StatelessWidget {
  final String? selectedClass;
  final List<String> classes;
  final ValueChanged<String?> onChanged;

  const ClassSelectionCard({
    Key? key,
    required this.selectedClass,
    required this.classes,
    required this.onChanged,
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
          const Text(
            'Select Class',
            style: TextStyle(
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
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text(
                  'Choose a class',
                  style: TextStyle(color: Colors.white70),
                ),
                value: selectedClass,
                dropdownColor: AppColors.primary,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: [
                  const DropdownMenuItem(
                    value: 'All Classes',
                    child: Text('All Classes', style: TextStyle(color: Colors.white)),
                  ),
                  ...classes.map((String className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(
                        className,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
