import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/state_views.dart';
import '../../recipes/models/recipe.dart';
import '../../recipes/presentation/recipe_details_screen.dart';
import '../../recipes/presentation/widgets/recipe_card.dart';
import '../../recipes/providers/recipe_providers.dart';
import '../providers/favorites_provider.dart';

/// "Favorites" tab: the same recipe cards as Home, filtered to favorites.
/// Removing a favorite here (or anywhere else) updates this list at once.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteRecipesProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Text('Favorites', style: AppTextStyles.title),
          ),
          Expanded(
            child: favorites.when(
              skipLoadingOnRefresh: false,
              loading: () => const LoadingView(),
              error: (error, _) => Center(
                child: ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(recipesProvider),
                ),
              ),
              data: (list) => list.isEmpty
                  ? const Center(
                      child: EmptyView(
                        icon: Icons.favorite_border,
                        message:
                            'No favorites yet.\nTap the heart on a recipe to save it.',
                      ),
                    )
                  : _FavoriteList(recipes: list),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  const _FavoriteList({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: recipes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => RecipeCard(
        recipe: recipes[index],
        onTap: () => RecipeDetailsScreen.open(context, recipes[index]),
      ),
    );
  }
}
