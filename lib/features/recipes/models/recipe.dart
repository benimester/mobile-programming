class Ingredient {
  const Ingredient(this.name, this.amount, this.unit);

  final String name;
  final double amount; // amount for the recipe's default servings
  final String unit;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.minutes,
    required this.imageUrl,
    required this.energyKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servings,
    required this.ingredients,
  });

  final String id;
  final String title;
  final String category;
  final int minutes;
  final String imageUrl;
  final int energyKcal;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int servings;
  final List<Ingredient> ingredients;
}
