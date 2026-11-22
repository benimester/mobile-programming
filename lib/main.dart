import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_shell.dart';
import 'core/storage/shared_preferences_provider.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  // Needed before using plugins (SharedPreferences) ahead of runApp.
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    // ProviderScope holds the state of every Riverpod provider.
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      // Riverpod 3 retries failed providers automatically by default. We turn
      // that off so a failed request shows the error state and the user
      // decides with the Retry button.
      retry: (retryCount, error) => null,
      child: const MealPlannerApp(),
    ),
  );
}

class MealPlannerApp extends StatelessWidget {
  const MealPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}
