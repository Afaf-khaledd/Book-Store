import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../User/features/data/models/OrderModel.dart';

class OrderRepository{

  final _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> fetchAllOrders() async {
    final querySnapshot = await _firestore.collection('orders').get();
    return querySnapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data()))
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
        .map((doc) => OrderModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final orderRef = _firestore.collection('orders').doc(orderId);
    final orderSnapshot = await orderRef.get();

    if (orderSnapshot.exists) {
      final orderData = orderSnapshot.data() as Map<String, dynamic>;
      final items = orderData['items'] as List<dynamic>;

      // Update the order status
      await orderRef.update({'status': status});

      if (status == 'confirmed') {
        // Loop through each order item and update the book availability and sales count
        for (var item in items) {
          final bookId = item['bookId']; // Assuming each item has a 'bookId'
          final quantity = item['quantity']; // Assuming each item has a 'quantity' field

          final bookRef = _firestore.collection('books').doc(bookId);

          // Fetch the book document
          final bookSnapshot = await bookRef.get();

          if (bookSnapshot.exists) {
            final bookData = bookSnapshot.data() as Map<String, dynamic>;
            final currentAvailability = bookData['availability'] ?? 0;
            final currentSalesCount = bookData['saleCount'] ?? 0;

            // Decrease availability by the ordered quantity and increase salesCount by the ordered quantity
            await bookRef.update({
              'availability': currentAvailability - quantity,
              'saleCount': currentSalesCount + quantity,
            });
          }
        }
      }
    }
  }
}