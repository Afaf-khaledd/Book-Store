import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../User/features/data/models/OrderModel.dart';

class OrderRepository{

  final _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> fetchAllOrders() async {
    final querySnapshot = await _firestore.collection('orders').get();
    return querySnapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderModel>> fetchOrdersByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('orders')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({'status': status});

  }
}