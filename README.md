# Meal Planner

Flutter mobile programming lab, built sprint by sprint from the Meal Planner
Figma design, for Android and iOS (minimum iOS 27.0).

- **Sprint 1** ("From Figma to Flutter"): Home and Recipe Details screens.
- **Sprint 2** ("API Integration & Persistent Favorites"): recipes from a REST
  API, loading / error / empty states, favorites saved on the device.

## Run

```sh
flutter pub get
flutter run
flutter test
```

## Structure (feature-based)

```text
lib/
├── main.dart                       entry: loads SharedPreferences, ProviderScope, MaterialApp
├── core/
│   ├── app_shell.dart              bottom navigation + tabs (Today, Favorites)
│   ├── theme/                      design system: colors, spacing, text styles, theme
│   ├── network/dio_provider.dart   the one Dio configuration (base URL, timeouts)
│   ├── storage/                    SharedPreferences provider
│   └── widgets/state_views.dart    LoadingView, ErrorView (with Retry), EmptyView
└── features/
    ├── home/presentation/          HomeScreen, ProgressCard, MacroRing
    ├── recipes/
    │   ├── models/                 Recipe, Ingredient (domain models)
    │   ├── data/                   MealDto, RecipeApiService, RecipeRepository
    │   ├── providers/              Riverpod providers wiring the layers together
    │   └── presentation/           RecipeDetailsScreen, RecipeCard
    └── favorites/
        ├── data/                   FavoritesRepository (SharedPreferences)
        ├── providers/              FavoritesNotifier, favoriteRecipesProvider
        └── presentation/           FavoritesScreen, FavoriteButton
```

## Sprint 1

- **Reusable widgets:** `RecipeCard`, `MacroRing` and `ProgressCard` get all
  their data through constructor parameters.
- **Navigation:** `Navigator.push` with a `MaterialPageRoute` passes the tapped
  `Recipe` to `RecipeDetailsScreen`; the back button calls `Navigator.pop`.

## Sprint 2

### Layers

```text
TheMealDB REST API
      │  JSON
      ▼
RecipeApiService   (Dio)       HTTP only: sends the request, JSON → MealDto
      │  MealDto
      ▼
RecipeRepository               MealDto → Recipe, errors → RecipeException
      │  Recipe / RecipeException
      ▼
recipesProvider    (Riverpod)  holds the result as AsyncValue: loading / data / error
      │
      ▼
HomeScreen, FavoritesScreen    show one view per state, Retry = ref.invalidate(...)
```

Each layer only knows the one directly below it, so each can be changed or
replaced on its own:

- **API service** – the only place that talks HTTP. It uses one shared `Dio`
  instance (`dioProvider`) with the base URL and timeouts.
- **Repository** – the single source of truth for recipes. It maps DTOs to
  domain models and turns every failure into a `RecipeException` with a
  readable message: specific ones for Dio errors (timeout, no internet, server
  error), a generic one for anything else (e.g. unexpected JSON). Screens
  never see Dio, JSON or DTOs.
- **Providers** – Riverpod connects the layers (`recipeApiServiceProvider` →
  `recipeRepositoryProvider` → `recipesProvider`) and holds the state.
- **UI** – widgets only watch providers and render. `AsyncValue.when` gives a
  separate branch for loading, error (with a Retry button) and data, and an
  empty list shows the empty state.

### Why Riverpod

- **Async state built in.** `FutureProvider` exposes the request as an
  `AsyncValue`, so loading / error / data are explicit and none can be
  forgotten. Retry is just `ref.invalidate(recipesProvider)`.
- **Shared state without passing it down.** The favorites live in one
  `NotifierProvider`. Home cards, Details and the Favorites tab all watch it,
  so a change on one screen shows on the others at once, with no callbacks
  through constructors and no `setState` in parents.
- **Dependency injection.** Providers build their dependencies through `ref`,
  so a test can override one (`recipeRepositoryProvider` with a fake,
  `sharedPreferencesProvider` with mock storage) and the widget tests never
  touch the network.
- **Efficient rebuilds.** `FavoriteButton` uses `select` and only rebuilds
  when its own recipe's favorite flag changes.
- It is also the state management solution chosen by the course.

`setState` is still used where state is local to one widget (the selected tab
in `AppShell`). Riverpod is only for state that is shared or comes from outside.

Riverpod 3 retries failed providers automatically by default. This is turned
off in `ProviderScope` (`retry: (_, _) => null`) so a failed request shows the
error state right away and the user decides when to retry.

### DTO vs domain model

- **`MealDto`** (`recipes/data/meal_dto.dart`) mirrors TheMealDB's JSON
  exactly: field names like `strMeal`, every field nullable, the 20 numbered
  `strIngredientN` / `strMeasureN` fields collected into raw lists.
- **`Recipe`** (`recipes/models/recipe.dart`) is what the app works with:
  clean names, non-null where the UI needs a value, a real `List<Ingredient>`.
- **`MealDto.toRecipe()`** is the only place where the two meet. It trims
  text, drops empty ingredient slots, fills named defaults (`Untitled recipe`,
  `Other`, `Unknown`, `To taste`) and returns `null` for meals without an id,
  which the repository skips.

Why the split: the API's shape is not under our control. If it renames a
field or we switch to another API, only the DTO and its mapping change; the
screens, the favorites and the tests built on `Recipe` stay the same. All
null checks are in one place instead of spread over the widgets.

Gaps in the API are decided in the domain model, not hidden: TheMealDB has no
nutrition data, so the nutrition fields are nullable and Details shows `N/A`
instead of made-up numbers. It has no cooking time either, so the subtitle is
"category / area" (e.g. "Dessert / Uruguayan"). Ingredient measures are free
text ("1 1/2 L", "To taste"), so they are shown as-is and the servings +/-
control from sprint 1 was removed.

### Why SharedPreferences for favorites

- **The data is tiny and simple.** Only the favorite recipe IDs are stored, as
  one string list (`favorite_recipe_ids`). The recipe data itself always comes
  from the repository, so there is nothing to keep in sync.
- **Key-value is enough.** There are no relations, queries or large records,
  which is what SQLite would be for (the course slides suggest
  SharedPreferences or SQLite for favorites).
- **Synchronous reads after one load.** `main()` awaits
  `SharedPreferences.getInstance()` once and injects it through
  `sharedPreferencesProvider`. After that `FavoritesNotifier.build()` reads the
  IDs synchronously, so favorites never need their own loading state.
- **Persistence is behind a repository.** `FavoritesRepository` has just
  `load()` and `save()`, so moving to SQLite later would not touch the
  notifier or the UI.

`toggle()` updates the state first and saves in the background, so the heart
reacts instantly. A restart creates a new notifier, which loads the saved IDs
again (covered by `test/favorites_test.dart`).

### Tests

- `widget_test.dart` – navigation, error → Retry, empty state, a favorite
  added on Home appearing on the Favorites tab (uses a fake repository).
- `meal_dto_test.dart` – JSON → `Recipe` mapping, defaults, skipped meals.
- `recipe_repository_test.dart` – Dio and non-Dio errors become `RecipeException`.
- `favorites_test.dart` – toggling, and favorites surviving a restart.
