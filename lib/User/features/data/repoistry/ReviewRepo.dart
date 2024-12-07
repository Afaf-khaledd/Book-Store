import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ReviewModel.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ReviewModel>> fetchReviews(String bookId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('bookId', isEqualTo: bookId)
          .get();

      return snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  Future<void> submitReview(ReviewModel review) async {
    try {
      await _firestore.collection('reviews').add(review.toMap());
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }
}
