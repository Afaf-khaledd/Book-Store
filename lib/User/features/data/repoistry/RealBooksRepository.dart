import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/BookModel.dart';
import 'BooksRepo.dart';

class RealBooksRepository implements BooksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio();
  final String _googleBooksBaseUrl = 'https://www.googleapis.com/books/v1/volumes';
  final String _key = 'AIzaSyBAWDz7i41WI-3R8pKzvLud7kt7MGZ5nEw';

  @override
  Future<List<BookModel>> fetchBooksFromApi({required List<String> categories}) async {
    try {
      List<BookModel> books = [];
      for (String category in categories) {
        String url = '$_googleBooksBaseUrl?q=subject:$category&key=$_key';
        final response = await _dio.get(url);

        if (response.statusCode == 200) {
          var data = response.data['items'] as List?;
          if (data != null) {
            books.addAll(
              data.map((bookJson) {
                var book = BookModel.fromJson(bookJson);
                book.category = category;
                return book;
              }).toList(),
            );
          }
        }
      }
      return books;
    } catch (e) {
      print('Error fetching books from API: $e');
      return [];
    }
  }
  @override
  Future<void> saveBooksToFirebase(List<BookModel> books) async {
    try {
      final batch = _firestore.batch();
      for (var book in books) {
        DocumentReference bookRef = _firestore.collection('books').doc(book.id);
        batch.set(bookRef, book.toJson());
      }
      await batch.commit();
    } catch (e) {
      print('Error saving books to Firebase: $e');
    }
  }
  @override
  Future<List<BookModel>> fetchBooksFromFirebase() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList();
      }
    } catch (e) {
      print('Error fetching books from Firebase: $e');
    }
    return [];
  }

  @override
  Future<List<BookModel>> fetchBooksByCategoryFromFirebase(String category) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => BookModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching books by category from Firebase: $e');
      return [];
    }
  }
}
