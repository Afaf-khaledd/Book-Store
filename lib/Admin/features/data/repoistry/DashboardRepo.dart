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
    // Step 1: Get orders
    final ordersSnapshot = await _firestore
        .collection('orders')
        .get(const GetOptions(source: Source.server));

    // Step 2: Initialize category count map
    final Map<String, int> categoryCounts = {};

    // Step 3: Loop through each order and count categories from book items
    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data();
      final List<dynamic> items = orderData['items'] ?? [];

      for (var item in items) {
        final bookId = item['bookId'];

        if (bookId != null) {
          // Step 4: Fetch the book and its category
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

    // Step 5: Fetch category names from the categories collection
    final categoriesSnapshot = await _firestore
        .collection('categories')
        .get(const GetOptions(source: Source.server));

    final categoryList = categoriesSnapshot.docs.map((doc) {
      final id = doc.id;
      final name = doc['name'];
      final count = categoryCounts[id] ?? 0;
      return {'id': id, 'name': name, 'count': count};
    }).toList();

    // Step 6: Sort categories by count in descending order
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