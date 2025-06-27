import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthy_food_app/screens/meal_list_screen.dart';
import 'package:healthy_food_app/providers/meal_provider.dart';

void main() {
  testWidgets('MealListScreen shows loading and empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => MealProvider())],
        child: MaterialApp(home: MealListScreen()),
      ),
    );
    // Should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    // Should show empty state after loading
    expect(find.text('No meals found.'), findsOneWidget);
  });
}
