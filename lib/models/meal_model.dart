class Meal {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final Map<String, dynamic> nutrition;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  final bool isPremium;
  final double latitude;
  final double longitude;
  final double price;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.nutrition,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.isPremium,
    required this.latitude,
    required this.longitude,
    required this.price,
  });

  factory Meal.fromMap(Map<String, dynamic> map, String id) {
    // Support both nutrition map and individual fields
    Map<String, dynamic> nutrition = {};
    if (map['nutrition'] != null) {
      nutrition = Map<String, dynamic>.from(map['nutrition']);
    } else {
      // Try to build nutrition from individual fields
      for (var key in ['calories', 'carbs', 'fat', 'protein']) {
        if (map[key] != null) nutrition[key] = map[key];
      }
    }
    return Meal(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      nutrition: nutrition,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      category: map['category'] ?? '',
      isPremium: map['isPremium'] == true,
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'nutrition': nutrition,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
      'isPremium': isPremium,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
    };
  }
}
