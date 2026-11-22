import 'package:shared_preferences/shared_preferences.dart';

/// Saves the favorite recipe IDs locally. Only the IDs are stored: the recipe
/// data itself always comes from the RecipeRepository.
class FavoritesRepository {
  const FavoritesRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'favorite_recipe_ids';

  Set<String> load() => (_prefs.getStringList(_key) ?? []).toSet();

  Future<void> save(Set<String> ids) =>
      _prefs.setStringList(_key, ids.toList());
}
