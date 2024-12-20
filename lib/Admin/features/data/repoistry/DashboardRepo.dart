import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchTotalUsers() async {
    final snapshot = await _firestore
        .collection('users')
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.length;
  }

  Future<int> fetchTotalOrders() async {
    final snapshot = await _firestore
        .collection('orders')
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.length;
  }

  Future<int> fetchTotalBooks() async {
    final snapshot = await _firestore
        .collection('books')
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.length;
  }

  Future<int> fetchTotalCategories() async {
    final snapshot = await _firestore
        .collection('categories')
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.length;
  }

  Future<List<Map<String, dynamic>>> fetchPopularCategories() async {

    final ordersSnapshot = await _firestore
        .collection('orders')
        .get(const GetOptions(source: Source.server));

    final Map<String, int> categoryCounts = {};
    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data();
      final List<dynamic> items = orderData['items'] ?? [];

      for (var item in items) {
        final bookId = item['bookId'];

        if (bookId != null) {
          final bookDoc = await _firestore.collection('books').doc(bookId).get();

          if (bookDoc.exists) {
            final bookData = bookDoc.data();
            final category = bookData?['category'];

            if (category != null) {
              categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
            }
          }
        }
      }
    }
    final categoriesSnapshot = await _firestore
        .collection('categories')
        .get(const GetOptions(source: Source.server));

    final categoryList = categoriesSnapshot.docs.map((doc) {
      final id = doc.id;
      final name = doc['name'];
      final count = categoryCounts[id] ?? 0;
      return {'id': id, 'name': name, 'count': count};
    }).toList();

    categoryList.sort((a, b) => b['count'].compareTo(a['count']));
    return categoryList;
  }


  Future<List<Map<String, dynamic>>> fetchBestSellingBooks() async {
    final snapshot = await _firestore
        .collection('books')
        .orderBy('saleCount', descending: true)
        .limit(5)
        .get(const GetOptions(source: Source.server));
    return snapshot.docs
        .map((doc) => {'title': doc['title'], 'sales': doc['saleCount']})
        .toList();
  }
}