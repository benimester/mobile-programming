import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../recipes/data/recipe_repository.dart';
import '../../recipes/models/recipe.dart';
import '../../recipes/presentation/recipe_details_screen.dart';
import 'widgets/progress_card.dart';
import 'widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // MP-05: push the details screen and hand over the selected recipe.
  void _openRecipe(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipes = const RecipeRepository().getRecipes();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceMuted,
                  child: Icon(Icons.person, color: AppColors.textSecondary),
                ),
                Icon(Icons.menu, size: 28),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const ProgressCard(
              calories: 1284,
              fatPercent: 29,
              proteinPercent: 65,
              carbsPercent: 85,
              message: "🎉 Keep the pace! You're doing great.",
            ),
            // Collection-for: one card per recipe.
            for (final recipe in recipes) ...[
              const SizedBox(height: AppSpacing.md),
              RecipeCard(
                recipe: recipe,
                onTap: () => _openRecipe(context, recipe),
              ),
            ],
          ],
        ),
      ),
      // Only "Today" exists in this sprint, the other tabs are placeholders.
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textPrimary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_outlined),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Grocery List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
