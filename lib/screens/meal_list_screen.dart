import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import 'meal_detail_screen.dart';
import '../utils/app_colors.dart';
import '../services/external_recipe_service.dart';
import '../providers/auth_provider.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  // ... (existing code)
  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  bool isLoading = false;
  String? error;

  Future<void> _fetchMeals() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      await Provider.of<MealProvider>(context, listen: false).fetchMeals();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showRandomMealDialog() async {
    final meal = await ExternalRecipeService.fetchRandomMeal();
    if (meal == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not fetch a random meal.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meal['strMeal'] ?? 'Random Meal'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meal['strMealThumb'] != null)
                Image.network(meal['strMealThumb'], height: 180),
              const SizedBox(height: 12),
              if (meal['price'] != null)
                Text(
                  'RM ' + (meal['price'] as double).toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              Text(
                meal['strInstructions'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final meals = mealProvider.filteredMeals;
    final categories = [
      'All',
      ...{for (final m in mealProvider.meals) m.category}
        ..removeWhere((c) => c.isEmpty),
    ];
    final colors = AppColors.of(context);
    final isPremiumUser = Provider.of<AuthProvider>(context).isPremium;
    if (meals.isEmpty) {
      return Center(child: Text('No meals found.'));
    }
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: IconThemeData(color: colors.heading),
        title: Text('Meals', style: TextStyle(color: colors.heading)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchMeals),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(child: Text('Error: $error'))
                : meals.isEmpty
                ? const Center(child: Text('No meals found.'))
                : ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, idx) {
                      final meal = meals[idx];
                      final isLocked = meal.isPremium && !isPremiumUser;
                      return GestureDetector(
                        onTap: isLocked
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MealDetailScreen(meal: meal),
                                  ),
                                );
                              },
                        child: Stack(
                          children: [
                            Card(
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
                                subtitle: Text(
                                  meal.category,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: meal.isPremium
                                    ? const Icon(
                                        Icons.lock,
                                        color: Colors.amber,
                                      )
                                    : null,
                              ),
                            ),
                            if (isLocked)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Center(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRandomMealDialog,
        icon: const Icon(Icons.casino),
        label: const Text('Random Healthy Meal'),
      ),
    );
  }
}
