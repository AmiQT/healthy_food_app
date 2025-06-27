import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_model.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  OrderProvider() {
    _loadOrdersFromCache();
  }

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> _loadOrdersFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_orders');
    if (cached != null) {
      final List<dynamic> decoded = jsonDecode(cached);
      _orders.clear();
      _orders.addAll(
        decoded.map(
          (m) => Order(
            id: m['id'],
            items: (m['items'] as List)
                .map(
                  (item) => OrderItem(
                    meal: Meal.fromMap(item['meal'], item['meal']['id']),
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
            total: m['total'],
            date: DateTime.parse(m['date']),
            status: m['status'],
          ),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> _saveOrdersToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final orderListJson = jsonEncode(
      _orders
          .map(
            (o) => {
              'id': o.id,
              'items': o.items
                  .map(
                    (item) => {
                      'meal': item.meal.toMap()..['id'] = item.meal.id,
                      'quantity': item.quantity,
                    },
                  )
                  .toList(),
              'total': o.total,
              'date': o.date.toIso8601String(),
              'status': o.status,
            },
          )
          .toList(),
    );
    await prefs.setString('cached_orders', orderListJson);
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
    _saveOrdersToCache();
  }

  void markOrderCompleted(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx].status = 'Completed';
      notifyListeners();
      _saveOrdersToCache();
    }
  }

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showOrderStatusNotification(String status) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'order_status_channel',
          'Order Status Updates',
          channelDescription: 'Notifications for order status changes',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Order Status Updated',
      'Your order status is now: $status',
      platformChannelSpecifics,
    );
  }

  void advanceOrderStatus(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final order = _orders[idx];
      final next =
          Order.statuses.indexOf(order.status) < Order.statuses.length - 1
          ? Order.statuses[Order.statuses.indexOf(order.status) + 1]
          : order.status;
      order.status = next;
      notifyListeners();
      _showOrderStatusNotification(order.status);
      _saveOrdersToCache();
    }
  }
}
