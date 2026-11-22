import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/recipe_api_service.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';

// The layers are wired together here:
// Dio -> RecipeApiService -> RecipeRepository -> recipesProvider -> UI.
// Each layer gets the one below through `ref`, so a test can override any of
// them (e.g. a fake repository instead of the network).

final recipeApiServiceProvider = Provider<RecipeApiService>((ref) {
  return RecipeApiService(ref.watch(dioProvider));
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(ref.watch(recipeApiServiceProvider));
});

/// The recipe list as an AsyncValue: loading, data or error.
/// The screens call `ref.invalidate(recipesProvider)` to retry.
final recipesProvider = FutureProvider<List<Recipe>>((ref) {
  return ref.watch(recipeRepositoryProvider).getRecipes();
});
