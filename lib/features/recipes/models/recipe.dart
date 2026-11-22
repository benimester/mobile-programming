/// Domain models: what the app works with. They don't know about the API's
/// JSON shape (that is the DTO's job, see `data/meal_dto.dart`).
class Ingredient {
  const Ingredient(this.name, this.measure);

  final String name;

  /// Free text from the API, e.g. "100g", "1 1/2 L", "To taste".
  final String measure;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.ingredients,
    this.energyKcal,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });

  final String id;
  final String title;
  final String category;

  /// Cuisine, e.g. "Italian". TheMealDB has no cooking time, so the subtitle
  /// shows "category / area" instead of the design's "category / minutes".
  final String area;
  final String imageUrl;
  final List<Ingredient> ingredients;

  // Nullable: TheMealDB has no nutrition data. The UI shows a placeholder
  // instead of inventing numbers.
  final int? energyKcal;
  final int? proteinG;
  final int? carbsG;
  final int? fatG;
}
