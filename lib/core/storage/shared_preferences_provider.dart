import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences has to be loaded asynchronously, once. `main()` awaits it
/// before `runApp` and overrides this provider with the loaded instance, so
/// everything else can read it synchronously (no loading state for prefs).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main()');
});
