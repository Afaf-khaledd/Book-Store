import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewsAdminRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchReviewsWithBookNames() async {
    final reviewsSnapshot = await _firestore.collection('reviews').get();
    final booksSnapshot = await _firestore.collection('books').get();

    final books = {for (var doc in booksSnapshot.docs) doc.id: doc.data()['title']};

    return reviewsSnapshot.docs.map((doc) {
      final review = doc.data();
      final bookName = books[review['bookId']] ?? 'Unknown Book';
      return {
        'bookName': bookName,
        'username': review['username'] ?? 'Anonymous',
        'review': review['review'],
        'rating': review['rating'],
      };
    }).toList();
  }
}