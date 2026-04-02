import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class NumberedPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const NumberedPagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () {
                    onPageChanged(currentPage - 1);
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
            color: currentPage > 1 ? AppColors.primary : AppColors.textDisabled,
            iconSize: 20,
          ),
          const SizedBox(width: 4),
          ...List.generate(
            totalPages > 3 ? 3 : totalPages,
            (index) {
              int pageNum = index + 1;
              return GestureDetector(
                onTap: () {
                  onPageChanged(pageNum);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: currentPage == pageNum
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      pageNum.toString(),
                      style: TextStyle(
                        color: currentPage == pageNum
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: currentPage == pageNum
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    onPageChanged(currentPage + 1);
                  }
                : null,
            icon: const Icon(Icons.chevron_right),
            color: currentPage < totalPages
                ? AppColors.primary
                : AppColors.textDisabled,
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
