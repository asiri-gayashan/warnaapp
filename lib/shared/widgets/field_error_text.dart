import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FieldErrorText extends StatelessWidget {
  final String? message;

  const FieldErrorText({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 14,
            color: AppColors.error,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              message!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
