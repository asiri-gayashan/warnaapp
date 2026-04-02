import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StudentSearchFilter extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback onClearSearch;

  const StudentSearchFilter({
    Key? key,
    required this.searchController,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onSearchChanged,
    required this.onClearSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or roll number...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: onClearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),

          // Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 6),
                _buildFilterChip('Paid'),
                const SizedBox(width: 6),
                _buildFilterChip('Pending'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => onFilterChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
