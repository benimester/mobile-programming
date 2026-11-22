import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'macro_ring.dart';

/// "Today's Progress" card: calories, three macro rings and a coach message.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.calories,
    required this.fatPercent,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.message,
  });

  final int calories;
  final int fatPercent;
  final int proteinPercent;
  final int carbsPercent;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textPrimary),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded: on narrow screens the title wraps instead of
              // overflowing into "View more".
              const Expanded(
                child: Text("Today's Progress", style: AppTextStyles.heading),
              ),
              Text(
                'View more',
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calories', style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text('$calories', style: AppTextStyles.heading),
                      ],
                    ),
                  ],
                ),
              ),
              MacroRing(
                label: 'Fat',
                percent: fatPercent,
                color: AppColors.fat,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroRing(
                label: 'Pro',
                percent: proteinPercent,
                color: AppColors.protein,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroRing(
                label: 'Carb',
                percent: carbsPercent,
                color: AppColors.carbs,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.surfaceMuted,
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
