import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_model.dart';

class MealProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Meal> _meals = [];
  final List<String> _favorites = [];
  final Map<String, int> _cart = {};

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showPremium = false;

  List<Meal> get meals => _meals;
  List<String> get favorites => _favorites;
  Map<String, int> get cart => _cart;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get showPremium => _showPremium;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  set selectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  set showPremium(bool value) {
    _showPremium = value;
    notifyListeners();
  }

  List<Meal> get filteredMeals {
    return _meals.where((meal) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          meal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          meal.ingredients.any(
            (i) => i.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      final matchesCategory =
          _selectedCategory == 'All' || meal.category == _selectedCategory;
      final matchesPremium = !_showPremium ? !meal.isPremium : true;
      return matchesSearch && matchesCategory && matchesPremium;
    }).toList();
  }

  Future<void> fetchMeals() async {
    try {
      final snapshot = await _firestore.collection('meals').get();
      _meals = snapshot.docs
          .map((doc) => Meal.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
      // Cache meals as JSON
      final prefs = await SharedPreferences.getInstance();
      final mealListJson = jsonEncode(
        _meals.map((m) => m.toMap()..['id'] = m.id).toList(),
      );
      await prefs.setString('cached_meals', mealListJson);
    } catch (e) {
      // On error, try to load cached meals
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_meals');
      if (cached != null) {
        final List<dynamic> decoded = jsonDecode(cached);
        _meals = decoded.map((m) => Meal.fromMap(m, m['id'])).toList();
        notifyListeners();
      }
      rethrow;
    }
  }

  void addToFavorites(String mealId) {
    if (!_favorites.contains(mealId)) {
      _favorites.add(mealId);
      notifyListeners();
    }
  }

  void removeFromFavorites(String mealId) {
    _favorites.remove(mealId);
    notifyListeners();
  }

  void addToCart(String mealId) {
    _cart.update(mealId, (qty) => qty + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeFromCart(String mealId) {
    if (_cart.containsKey(mealId)) {
      if (_cart[mealId] != null && _cart[mealId]! > 1) {
        _cart[mealId] = _cart[mealId]! - 1;
      } else {
        _cart.remove(mealId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  List<MapEntry<Meal, int>> getCartMealsWithQuantity() {
    return _cart.entries
        .where((e) => _meals.any((m) => m.id == e.key))
        .map((e) => MapEntry(_meals.firstWhere((m) => m.id == e.key), e.value))
        .toList();
  }
}
