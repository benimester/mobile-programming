# Meal Planner

Flutter mobile programming lab, sprint 1 ("From Figma to Flutter"): Home screen
and Recipe Details screen of the Meal Planner design, for Android and iOS
(minimum iOS 27.0).

## Run

```
flutter pub get
flutter run
flutter test
```

## Structure (feature-based)

```
lib/
├── main.dart                     app entry, MaterialApp + theme
├── core/theme/                   design system: colors, spacing, text styles, theme
└── features/
    ├── home/presentation/        HomeScreen + widgets (ProgressCard, MacroRing, RecipeCard)
    └── recipes/
        ├── models/               Recipe, Ingredient
        ├── data/                 RecipeRepository (hardcoded data)
        └── presentation/         RecipeDetailsScreen
```

- **Reusable widgets:** `RecipeCard`, `MacroRing` and `ProgressCard` get all
  their data through constructor parameters.
- **Navigation:** `Navigator.push` with a `MaterialPageRoute` passes the tapped
  `Recipe` to `RecipeDetailsScreen`; the back button calls `Navigator.pop`.
