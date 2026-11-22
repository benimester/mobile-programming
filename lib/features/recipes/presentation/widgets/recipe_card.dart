import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../favorites/presentation/widgets/favorite_button.dart';
import '../../models/recipe.dart';

/// Image card of one recipe. It only knows the [Recipe] it shows and reports
/// taps through [onTap], so it can be reused on any screen (Home, Favorites).
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                // Shown when the image cannot be loaded (e.g. offline).
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: AppColors.surfaceMuted,
                  child: Icon(Icons.restaurant, size: 48),
                ),
              ),
              // Dark gradient so the white title stays readable.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: FavoriteButton(recipeId: recipe.id),
              ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${recipe.category} / ${recipe.area}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
