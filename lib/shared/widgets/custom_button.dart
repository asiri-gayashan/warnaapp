import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderRadius;
  final bool isFullWidth;
  final bool hasShadow;
  final double elevation;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 48,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 12,
    this.isFullWidth = true,
    this.hasShadow = false,
    this.elevation = 0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      decoration: hasShadow ? BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ) : null,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? const Color(0xFF9CA3AF)
              : (backgroundColor ?? const Color(0xFF4F46E5)),
          foregroundColor: isDisabled
              ? const Color(0xFFF9FAFB)
              : (textColor ?? Colors.white),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor ?? Colors.white,
          ),
        )
            : Text(
          text,
          style: textStyle ?? const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}

// New Outline Button Variant
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final bool isFullWidth;

  const CustomOutlineButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 48,
    this.textColor,
    this.borderColor,
    this.backgroundColor = Colors.white,
    this.borderRadius = 12,
    this.isFullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? const Color(0xFF4F46E5),
          side: BorderSide(
            color: isDisabled
                ? const Color(0xFFD1D5DB)
                : (borderColor ?? const Color(0xFF4F46E5)),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor ?? const Color(0xFF4F46E5),
          ),
        )
            : Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDisabled
                ? const Color(0xFF9CA3AF)
                : (textColor ?? const Color(0xFF4F46E5)),
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}