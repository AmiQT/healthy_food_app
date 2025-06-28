import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthy_food_app/widgets/shimmer_loader.dart';

void main() {
  group('LocationMapWidget Tests', () {
    testWidgets('should display title when provided', (
      WidgetTester tester,
    ) async {
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

      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('should not display title when not provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationMapWidget(latitude: 3.1390, longitude: 101.6869),
          ),
        ),
      );

      expect(find.text('Test Location'), findsNothing);
    });

    testWidgets('should handle invalid coordinates gracefully', (
      WidgetTester tester,
    ) async {
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

      // Should still display the title even with invalid coordinates
      expect(find.text('Invalid Location'), findsOneWidget);
    });

    testWidgets('should have correct default height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationMapWidget(latitude: 3.1390, longitude: 101.6869),
          ),
        ),
      );

      // Find the SizedBox containing the map
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(LocationMapWidget),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, 150.0);
    });

    testWidgets('should have custom height when specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationMapWidget(
              latitude: 3.1390,
              longitude: 101.6869,
              height: 200.0,
            ),
          ),
        ),
      );

      // Find the SizedBox containing the map
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(LocationMapWidget),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, 200.0);
    });
  });
}
