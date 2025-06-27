import 'package:flutter/foundation.dart';
import 'meal_model.dart';

class OrderItem {
  final Meal meal;
  final int quantity;
  OrderItem({required this.meal, required this.quantity});
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime date;
  String status; // 'Pending' or 'Completed'

  static const List<String> statuses = [
    'Pending',
    'Preparing',
    'Out for Delivery',
    'Completed',
  ];

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'Pending',
  });

  String get nextStatus {
    final idx = statuses.indexOf(status);
    if (idx >= 0 && idx < statuses.length - 1) {
      return statuses[idx + 1];
    }
    return status;
  }
}
