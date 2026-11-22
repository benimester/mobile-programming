import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../../recipes/models/recipe.dart';
import '../../recipes/providers/recipe_providers.dart';
import '../data/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(sharedPreferencesProvider));
});

/// The set of favorite recipe IDs, shared by every screen that watches it.
/// When it changes, all of them (Home cards, Details, Favorites tab) rebuild.
class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.watch(favoritesRepositoryProvider).load();

  void toggle(String recipeId) {
    // State is immutable: build a new Set so Riverpod sees the change.
    final updated = {...state};
    if (!updated.remove(recipeId)) updated.add(recipeId);
    state = updated;
    // The UI updates right away, saving happens in the background.
    ref.read(favoritesRepositoryProvider).save(updated);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);

/// Derived state: the loaded recipes filtered by the favorite IDs.
/// It stays an AsyncValue, because the recipe list itself is async.
final favoriteRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return ref
      .watch(recipesProvider)
      .whenData((recipes) => recipes.where((r) => ids.contains(r.id)).toList());
});
