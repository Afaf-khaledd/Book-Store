import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/OrderModel.dart';

class OrderRepository{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId, List<OrderItem> cartItems, double totalPrice) async {
    try {
      final orderId = _firestore.collection('orders').doc().id;
      final DateTime orderDate = DateTime.now();

      await _firestore.collection('orders').doc(orderId).set({
        'userId': userId,
        'orderId': orderId,
        'date': orderDate,
        'totalCost': totalPrice,
        'status': 'pending',
        'items': cartItems.map((item) {
          return {
            'bookId': item.bookId,
            'bookTitle': item.bookTitle,
            'quantity': item.quantity,
            'costPerItem': item.costPerItem,
            'totalCost': item.quantity * item.costPerItem,
          };
        }).toList(),
      });

      await _firestore.collection('users').doc(userId).collection('cart').get().then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print("Error placing order: $e");
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      print("Error cancelling order: $e");
    }
  }
}