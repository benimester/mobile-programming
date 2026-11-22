import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/storage/shared_preferences_provider.dart';
import 'package:mobile/features/favorites/providers/favorites_provider.dart';

/// A fresh ProviderContainer works like a fresh app start: nothing is kept in
/// memory, only what SharedPreferences saved.
ProviderContainer _startApp(SharedPreferences prefs) {
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('toggle adds and removes a favorite', () async {
    SharedPreferences.setMockInitialValues({});
    final container = _startApp(await SharedPreferences.getInstance());
    final notifier = container.read(favoritesProvider.notifier);

    notifier.toggle('42');
    expect(container.read(favoritesProvider), {'42'});

    notifier.toggle('42');
    expect(container.read(favoritesProvider), isEmpty);
  });

  test('favorites survive an app restart', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    _startApp(prefs).read(favoritesProvider.notifier).toggle('42');

    // "Restart": a new container reading the same storage.
    expect(_startApp(prefs).read(favoritesProvider), {'42'});
  });
}
