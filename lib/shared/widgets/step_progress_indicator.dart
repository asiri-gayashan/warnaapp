import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const StepProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step Numbers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isActive = stepNumber == currentStep;
            final isCompleted = stepNumber < currentStep;

            return Column(
              children: [
                // Step Circle
                Container(
                  width: 36,
                  height: 36,
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
                      size: 20,
                      color: Colors.white,
                    )
                        : Text(
                      '$stepNumber',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Step Label
                Text(
                  stepLabels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCompleted || isActive
                        ? AppColors.stepActive
                        : AppColors.stepInactive,
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
          margin: const EdgeInsets.symmetric(horizontal: 18),
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
                widthFactor: (currentStep - 1) / (totalSteps - 1),
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