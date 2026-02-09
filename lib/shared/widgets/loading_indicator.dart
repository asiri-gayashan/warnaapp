import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.size = 24,
    this.color = AppColors.primary,
    this.strokeWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}