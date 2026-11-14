import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/recipe.dart';

/// Stateful, because the selected number of servings changes on this screen.
class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late int _servings = widget.recipe.servings;

  void _changeServings(int delta) {
    if (_servings + delta < 1) return;
    setState(() => _servings += delta);
  }

  /// Ingredient amount scaled to the selected servings, e.g. "250 g".
  String _amountLabel(Ingredient ingredient) {
    final amount = ingredient.amount * _servings / widget.recipe.servings;
    final text = amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(1);
    return '$text ${ingredient.unit}';
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final imageHeight = MediaQuery.sizeOf(context).height * 0.45;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Photo at the top.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const ColoredBox(
                color: AppColors.surfaceMuted,
                child: Icon(Icons.restaurant, size: 64),
              ),
            ),
          ),

          // 2. White sheet overlapping the photo.
          Positioned.fill(
            top: imageHeight - AppSpacing.radiusLg,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(recipe.title, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${recipe.category} / ${recipe.minutes} mins',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _NutritionRow(recipe: recipe),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Ingredients',
                            style: AppTextStyles.heading,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '$_servings servings',
                            style: AppTextStyles.caption,
                          ),
                          const Spacer(),
                          IconButton.outlined(
                            onPressed: () => _changeServings(-1),
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton.outlined(
                            onPressed: () => _changeServings(1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        children: [
                          for (final ingredient in recipe.ingredients)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ingredient.name,
                                    style: AppTextStyles.body,
                                  ),
                                  Text(
                                    _amountLabel(ingredient),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: FilledButton(
                        // The Preparation screen is not part of sprint 1.
                        onPressed: () {},
                        child: const Text('Start cooking'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Back button over the photo (MP-05: pop returns to Home).
          // Positioned like the other children: a Stack with only positioned
          // children fills the whole screen instead of shrinking to the button.
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.textPrimary,
                  ),
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey strip with the four nutrition values.
class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NutritionItem('${recipe.energyKcal} kcal', 'Energy'),
          _NutritionItem('${recipe.proteinG} g', 'Protein'),
          _NutritionItem('${recipe.carbsG} g', 'Carbs'),
          _NutritionItem('${recipe.fatG} g', 'Fat'),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  const _NutritionItem(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.caption),
        Text(label, style: AppTextStyles.body),
      ],
    );
  }
}
