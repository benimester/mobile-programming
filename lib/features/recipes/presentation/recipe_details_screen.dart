import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../favorites/presentation/widgets/favorite_button.dart';
import '../models/recipe.dart';

/// Stateless: the recipe comes in through the constructor, and the only
/// changing thing on this screen (the favorite flag) lives in Riverpod.
class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key, required this.recipe});

  final Recipe recipe;

  /// Opens the details of [recipe]. Home and Favorites both use it.
  static void open(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: _DetailsSheet(recipe: recipe),
          ),

          // 3. Back and favorite buttons over the photo.
          // Positioned like the other children: a Stack with only positioned
          // children fills the whole screen instead of shrinking to the buttons.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: AppColors.textPrimary,
                      ),
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    FavoriteButton(recipeId: recipe.id),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The rounded white sheet: title, nutrition, ingredients, button.
class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                recipe.title,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${recipe.category} / ${recipe.area}',
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
                  const Text('Ingredients', style: AppTextStyles.heading),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${recipe.ingredients.length} items',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Expanded(child: _IngredientList(ingredients: recipe.ingredients)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: FilledButton(
                // The Preparation screen is not part of sprint 2.
                onPressed: () {},
                child: const Text('Start cooking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scrollable list of "name ... measure" rows.
class _IngredientList extends StatelessWidget {
  const _IngredientList({required this.ingredients});

  final List<Ingredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(child: Text(ingredient.name, style: AppTextStyles.body)),
              const SizedBox(width: AppSpacing.md),
              Text(ingredient.measure, style: AppTextStyles.caption),
            ],
          ),
        );
      },
    );
  }
}

/// Grey strip with the four nutrition values.
class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.recipe});

  final Recipe recipe;

  /// Shown for values the API doesn't provide (TheMealDB has no nutrition).
  static const _missing = 'N/A';

  String _format(int? value, String unit) =>
      value == null ? _missing : '$value $unit';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NutritionItem(_format(recipe.energyKcal, 'kcal'), 'Energy'),
          _NutritionItem(_format(recipe.proteinG, 'g'), 'Protein'),
          _NutritionItem(_format(recipe.carbsG, 'g'), 'Carbs'),
          _NutritionItem(_format(recipe.fatG, 'g'), 'Fat'),
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
