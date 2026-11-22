import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/storage/shared_preferences_provider.dart';
import 'package:mobile/features/recipes/data/recipe_repository.dart';
import 'package:mobile/features/recipes/models/recipe.dart';
import 'package:mobile/features/recipes/providers/recipe_providers.dart';
import 'package:mobile/main.dart';

/// Stands in for the real repository, so widget tests never hit the network.
/// [results] is consumed one call at a time: a `List<Recipe>` or an exception.
class FakeRecipeRepository implements RecipeRepository {
  FakeRecipeRepository(this.results);

  final List<Object> results;

  @override
  Future<List<Recipe>> getRecipes() async {
    final next = results.length > 1 ? results.removeAt(0) : results.first;
    if (next is Exception) throw next;
    return next as List<Recipe>;
  }
}

const _salad = Recipe(
  id: '1',
  title: 'Sesame Chicken Salad',
  category: 'Chicken',
  area: 'Japanese',
  imageUrl: '',
  ingredients: [Ingredient('Chicken breasts', '250g')],
);

Future<void> _pumpApp(
  WidgetTester tester,
  FakeRecipeRepository repository,
) async {
  // Use a phone-sized screen instead of the default 800x600 test surface.
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        recipeRepositoryProvider.overrideWithValue(repository),
      ],
      retry: (retryCount, error) => null,
      child: const MealPlannerApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Home opens the selected recipe and back returns to Home', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      FakeRecipeRepository([
        [_salad],
      ]),
    );
    expect(find.text("Today's Progress"), findsOneWidget);

    await tester.tap(find.text('Sesame Chicken Salad'));
    await tester.pumpAndSettle();
    expect(find.text('Start cooking'), findsOneWidget);
    expect(find.text('Chicken breasts'), findsOneWidget);
    expect(find.text('250g'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text("Today's Progress"), findsOneWidget);
  });

  testWidgets('Error state shows Retry, and Retry loads the recipes', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      FakeRecipeRepository([
        const RecipeException('No internet connection.'),
        [_salad],
      ]),
    );
    expect(find.text('No internet connection.'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Sesame Chicken Salad'), findsOneWidget);
  });

  testWidgets('Empty list shows the empty state', (tester) async {
    await _pumpApp(tester, FakeRecipeRepository([<Recipe>[]]));
    expect(find.text('No recipes found.'), findsOneWidget);
  });

  testWidgets('A favorite added on Home shows up on the Favorites tab', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      FakeRecipeRepository([
        [_salad],
      ]),
    );

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No favorites yet'), findsOneWidget);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Sesame Chicken Salad'), findsWidgets);
    expect(find.textContaining('No favorites yet'), findsNothing);
  });
}
