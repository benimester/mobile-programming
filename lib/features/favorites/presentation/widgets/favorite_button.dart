import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/favorites_provider.dart';

/// Heart button for one recipe. It reads and changes the shared favorites
/// state itself, so any screen can drop it in with just a recipe ID, and only
/// this small widget rebuilds when the favorite changes.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `select`: rebuild only when *this* recipe's favorite flag changes.
    final isFavorite = ref.watch(
      favoritesProvider.select((ids) => ids.contains(recipeId)),
    );

    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.background,
        foregroundColor: isFavorite ? AppColors.primary : AppColors.textPrimary,
      ),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(recipeId),
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
