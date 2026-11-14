import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Home opens the selected recipe and back returns to Home', (
    tester,
  ) async {
    // Use a phone-sized screen instead of the default 800x600 test surface.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MealPlannerApp());
    expect(find.text("Today's Progress"), findsOneWidget);

    await tester.tap(find.text('Sesame Chicken Salad'));
    await tester.pumpAndSettle();
    expect(find.text('Start cooking'), findsOneWidget);
    expect(find.text('Chicken breasts'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text("Today's Progress"), findsOneWidget);
  });
}
