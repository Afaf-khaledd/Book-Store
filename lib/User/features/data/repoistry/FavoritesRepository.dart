import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/BookModel.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBookToFavorites(String userId, BookModel book) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(book.id)
          .set(book.toJson());
    } catch (e) {
      print('Error adding book to favorites: $e');
    }
  }

  Future<void> removeBookFromFavorites(String userId, String bookId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(bookId)
          .delete();
    } catch (e) {
      print('Error removing book from favorites: $e');
    }
  }

  Future<List<BookModel>> getFavoriteBooks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      return snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching favorite books: $e');
      return [];
    }
  }
}