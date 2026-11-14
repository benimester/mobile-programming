import '../models/recipe.dart';

/// Hardcoded recipes for now. Later sprints can swap this for an API or a
/// database without touching the screens.
class RecipeRepository {
  const RecipeRepository();

  List<Recipe> getRecipes() => _recipes;
}

const _recipes = [
  Recipe(
    id: 'chicken-salad',
    title: 'Sesame Chicken Salad',
    category: 'Dinner',
    minutes: 25,
    imageUrl:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
    energyKcal: 420,
    proteinG: 32,
    carbsG: 24,
    fatG: 18,
    servings: 2,
    ingredients: [
      Ingredient('Chicken breasts', 250, 'g'),
      Ingredient('Baby spinach', 80, 'g'),
      Ingredient('Carrot', 1, 'pc'),
      Ingredient('Sesame seeds', 1, 'tbsp'),
      Ingredient('Soy sauce', 2, 'tbsp'),
    ],
  ),
  Recipe(
    id: 'grilled-skewers',
    title: 'Grilled Skewers',
    category: 'Dinner',
    minutes: 30,
    imageUrl:
        'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
    energyKcal: 380,
    proteinG: 28,
    carbsG: 30,
    fatG: 14,
    servings: 2,
    ingredients: [
      Ingredient('Chicken thighs', 300, 'g'),
      Ingredient('Red onion', 1, 'pc'),
      Ingredient('Bell pepper', 1, 'pc'),
      Ingredient('Olive oil', 2, 'tbsp'),
      Ingredient('Rice', 150, 'g'),
    ],
  ),
  Recipe(
    id: 'ramen',
    title: 'Ramen',
    category: 'Lunch',
    minutes: 15,
    imageUrl:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800&q=80',
    energyKcal: 480,
    proteinG: 15,
    carbsG: 58,
    fatG: 20,
    servings: 2,
    ingredients: [
      Ingredient('Ramen noodles', 200, 'g'),
      Ingredient('Unsalted butter', 1, 'tbsp'),
      Ingredient('Sesame or vegetable oil', 2, 'tsp'),
      Ingredient('Fresh ginger', 2, 'tsp'),
      Ingredient('Large eggs', 2, 'pc'),
      Ingredient('Soy sauce', 2, 'tbsp'),
    ],
  ),
];
