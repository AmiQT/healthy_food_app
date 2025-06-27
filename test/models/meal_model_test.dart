import 'package:flutter_test/flutter_test.dart';
import 'package:healthy_food_app/models/meal_model.dart';

void main() {
  group('Meal Model', () {
    test('fromMap and toMap', () {
      final map = {
        'name': 'Salad',
        'description': 'Healthy salad',
        'imageUrl': 'http://example.com/salad.jpg',
        'nutrition': {'calories': 100},
        'ingredients': ['Lettuce', 'Tomato'],
        'steps': ['Chop', 'Mix'],
        'category': 'Vegetarian',
        'isPremium': false,
        'latitude': 1.0,
        'longitude': 2.0,
      };
      final meal = Meal.fromMap(map, 'id123');
      expect(meal.name, 'Salad');
      expect(meal.nutrition['calories'], 100);
      expect(meal.ingredients.length, 2);
      expect(meal.latitude, 1.0);
      expect(meal.longitude, 2.0);
      final toMap = meal.toMap();
      expect(toMap['name'], 'Salad');
      expect(toMap['nutrition']['calories'], 100);
    });
  });
}
