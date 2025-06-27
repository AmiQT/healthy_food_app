import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import 'meal_detail_screen.dart';
import '../utils/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final favoriteMeals = mealProvider.meals
        .where((m) => mealProvider.favorites.contains(m.id))
        .toList();
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Favorites', style: TextStyle(color: colors.heading)),
      ),
      body: favoriteMeals.isEmpty
          ? Center(
              child: Text(
                'No favorite meals yet.',
                style: TextStyle(color: colors.bodyText),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = favoriteMeals[index];
                return Card(
                  color: colors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: meal.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              meal.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.fastfood,
                            size: 40,
                            color: colors.bodyText,
                          ),
                    title: Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'RM ' + meal.price.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailScreen(meal: meal),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
