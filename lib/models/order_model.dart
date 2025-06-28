import 'meal_model.dart';

class OrderItem {
  final Meal meal;
  final int quantity;

  OrderItem({required this.meal, required this.quantity});

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      meal: Meal.fromMap(map['meal'], map['meal']['id']),
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'meal': meal.toMap()..['id'] = meal.id, 'quantity': quantity};
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime date;
  String status;

  static const List<String> statuses = [
    'Ordered',
    'Preparing',
    'On the Way',
    'Completed',
  ];

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });

  String get nextStatus {
    final currentIndex = statuses.indexOf(status);
    if (currentIndex < statuses.length - 1) {
      return statuses[currentIndex + 1];
    }
    return status;
  }

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      items: (map['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      total: (map['total'] ?? 0.0).toDouble(),
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'Ordered',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
