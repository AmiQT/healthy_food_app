import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_model.dart';
import '../providers/meal_provider.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;
  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final isFavorite = mealProvider.favorites.contains(meal.id);
    final inCart = mealProvider.cart.containsKey(meal.id);
    final colors = AppColors.of(context);
    final isPremiumUser = Provider.of<AuthProvider>(context).isPremium;
    final isLocked = meal.isPremium && !isPremiumUser;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text(meal.name, style: TextStyle(color: colors.heading)),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              isFavorite
                  ? mealProvider.removeFromFavorites(meal.id)
                  : mealProvider.addToFavorites(meal.id);
            },
          ),
          IconButton(
            icon: Icon(inCart ? Icons.shopping_cart : Icons.add_shopping_cart),
            onPressed: isLocked
                ? null
                : () {
                    inCart
                        ? mealProvider.removeFromCart(meal.id)
                        : mealProvider.addToCart(meal.id);
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (meal.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    meal.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'RM ' + meal.price.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                meal.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Category: ${meal.category}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (meal.nutrition.isNotEmpty) ...[
                Text(
                  'Nutrition:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ...meal.nutrition.entries.map(
                  (e) => Text(
                    '${e.key}: ${e.value}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Ingredients:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...meal.ingredients.map(
                (i) =>
                    Text('- $i', style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(height: 16),
              Text(
                'Preparation Steps:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...meal.steps.asMap().entries.map(
                (e) => Text(
                  '${e.key + 1}. ${e.value}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          if (isLocked)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Unlock with Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
