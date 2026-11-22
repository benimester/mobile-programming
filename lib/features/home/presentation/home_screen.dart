import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/state_views.dart';
import '../../recipes/models/recipe.dart';
import '../../recipes/presentation/recipe_details_screen.dart';
import '../../recipes/presentation/widgets/recipe_card.dart';
import '../../recipes/providers/recipe_providers.dart';
import 'widgets/progress_card.dart';

/// "Today" tab. ConsumerWidget, so it can watch Riverpod providers.
/// The Scaffold and bottom navigation come from AppShell.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceMuted,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
              Icon(Icons.menu, size: 28),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Still static: daily tracking is not part of sprint 2.
          const ProgressCard(
            calories: 1284,
            fatPercent: 29,
            proteinPercent: 65,
            carbsPercent: 85,
            message: "🎉 Keep the pace! You're doing great.",
          ),
          // One branch per state of the AsyncValue.
          ...recipes.when(
            // Show the spinner on retry too, not the previous error.
            skipLoadingOnRefresh: false,
            loading: () => const [LoadingView()],
            error: (error, _) => [
              ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(recipesProvider),
              ),
            ],
            data: (list) => list.isEmpty
                ? const [EmptyView(message: 'No recipes found.')]
                : _recipeCards(context, list),
          ),
        ],
      ),
    );
  }

  List<Widget> _recipeCards(BuildContext context, List<Recipe> recipes) {
    return [
      for (final recipe in recipes) ...[
        const SizedBox(height: AppSpacing.md),
        RecipeCard(
          recipe: recipe,
          onTap: () => RecipeDetailsScreen.open(context, recipe),
        ),
      ],
    ];
  }
}
