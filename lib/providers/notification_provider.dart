import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    final snapshot = await _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();
    _notifications = snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

  int getUnreadCount(String userId) {
    return _notifications.where((n) => !n.readBy.contains(userId)).length;
  }

  Future<void> markAllAsRead(String userId) async {
    for (final n in _notifications) {
      if (!n.readBy.contains(userId)) {
        await _firestore.collection('notifications').doc(n.id).update({
          'readBy': FieldValue.arrayUnion([userId]),
        });
        n.readBy.add(userId);
      }
    }
    notifyListeners();
  }
}
