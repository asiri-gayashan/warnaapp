import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final stepNumber = index + 1;
            final isActive = stepNumber == currentStep;
            final isCompleted = stepNumber < currentStep;

            return Column(
              children: [
                // Step Circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.stepCompleted
                        : isActive
                        ? AppColors.stepActive
                        : AppColors.stepInactive,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                        : Text(
                      '$stepNumber',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Step Label
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCompleted || isActive
                        ? AppColors.stepActive
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 16),

        // Progress Bar
        Container(
          height: 4,
          margin: EdgeInsets.symmetric(
            horizontal: steps.length > 4 ? 8 : 16,
          ),
          child: Stack(
            children: [
              // Background Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.stepInactive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Progress Bar
              FractionallySizedBox(
                widthFactor: (currentStep - 1) / (steps.length - 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.stepActive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}