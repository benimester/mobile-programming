import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/recipes/data/meal_dto.dart';

void main() {
  test('maps a TheMealDB meal to a Recipe', () {
    final recipe = MealDto.fromJson({
      'idMeal': '53322',
      'strMeal': 'Flan',
      'strCategory': 'Dessert',
      'strArea': 'Uruguayan',
      'strMealThumb': 'https://example.com/flan.jpg',
      'strIngredient1': 'Sugar',
      'strMeasure1': '100g ',
      'strIngredient2': 'Dulce de leche',
      'strMeasure2': ' ',
      'strIngredient3': '',
      'strMeasure3': ' ',
    }).toRecipe()!;

    expect(recipe.id, '53322');
    expect(recipe.title, 'Flan');
    expect(recipe.area, 'Uruguayan');
    // Blank slots are dropped, measures trimmed, missing measure defaulted.
    expect(recipe.ingredients.length, 2);
    expect(recipe.ingredients[0].measure, '100g');
    expect(recipe.ingredients[1].measure, MealDto.defaultMeasure);
    // TheMealDB has no nutrition data.
    expect(recipe.energyKcal, isNull);
  });

  test('fills defaults for missing fields', () {
    final recipe = MealDto.fromJson({
      'idMeal': '1',
      'strMeal': null,
    }).toRecipe()!;

    expect(recipe.title, MealDto.defaultTitle);
    expect(recipe.category, MealDto.defaultCategory);
    expect(recipe.area, MealDto.defaultArea);
    expect(recipe.imageUrl, '');
    expect(recipe.ingredients, isEmpty);
  });

  test('a meal without an id is skipped', () {
    expect(MealDto.fromJson({'strMeal': 'Ghost'}).toRecipe(), isNull);
  });
}
