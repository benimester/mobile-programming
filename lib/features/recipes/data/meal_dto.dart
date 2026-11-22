import '../models/recipe.dart';

/// DTO (Data Transfer Object): mirrors one "meal" object of TheMealDB's JSON,
/// every field nullable because the API gives no guarantees.
/// `toRecipe()` maps it to the domain [Recipe]; nulls, blanks and defaults
/// are handled only there. If the API changes, only this file changes.
class MealDto {
  const MealDto({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strMealThumb,
    this.ingredients = const [],
    this.measures = const [],
  });

  final String? idMeal;
  final String? strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strMealThumb;

  /// The API has 20 numbered fields (strIngredient1..20, strMeasure1..20)
  /// instead of a list; they are collected here in order, raw.
  final List<String?> ingredients;
  final List<String?> measures;

  factory MealDto.fromJson(Map<String, dynamic> json) {
    return MealDto(
      idMeal: json['idMeal'] as String?,
      strMeal: json['strMeal'] as String?,
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strMealThumb: json['strMealThumb'] as String?,
      ingredients: [
        for (var i = 1; i <= 20; i++) json['strIngredient$i'] as String?,
      ],
      measures: [for (var i = 1; i <= 20; i++) json['strMeasure$i'] as String?],
    );
  }

  // Defaults for missing values, named so they are easy to find and change.
  static const defaultTitle = 'Untitled recipe';
  static const defaultCategory = 'Other';
  static const defaultArea = 'Unknown';
  static const defaultMeasure = 'To taste';

  /// Returns null when the meal is unusable (no id), so the caller can skip it.
  Recipe? toRecipe() {
    final id = _clean(idMeal);
    if (id == null) return null;

    return Recipe(
      id: id,
      title: _clean(strMeal) ?? defaultTitle,
      category: _clean(strCategory) ?? defaultCategory,
      area: _clean(strArea) ?? defaultArea,
      // An empty URL makes Image.network fail, which shows its errorBuilder.
      imageUrl: _clean(strMealThumb) ?? '',
      ingredients: _mapIngredients(),
    );
  }

  List<Ingredient> _mapIngredients() {
    final result = <Ingredient>[];
    for (var i = 0; i < ingredients.length; i++) {
      final name = _clean(ingredients[i]);
      if (name == null) continue; // unused slot ("" or null)
      final measure = i < measures.length ? _clean(measures[i]) : null;
      result.add(Ingredient(name, measure ?? defaultMeasure));
    }
    return result;
  }

  /// Trims the text; null and blank strings both become null.
  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
