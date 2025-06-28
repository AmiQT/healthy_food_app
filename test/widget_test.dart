// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthy_food_app/widgets/shimmer_loader.dart';

import 'package:healthy_food_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('LocationMapWidget test', (WidgetTester tester) async {
    // Test with valid coordinates
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationMapWidget(
            latitude: 3.1390,
            longitude: 101.6869,
            title: 'Test Location',
          ),
        ),
      ),
    );

    // Verify the title is displayed
    expect(find.text('Test Location'), findsOneWidget);

    // Test with invalid coordinates (should use fallback)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LocationMapWidget(
            latitude: 0.0,
            longitude: 0.0,
            title: 'Invalid Location',
          ),
        ),
      ),
    );

    // Verify the title is still displayed
    expect(find.text('Invalid Location'), findsOneWidget);
  });
}
