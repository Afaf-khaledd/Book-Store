import 'package:book_store/User/features/data/models/BookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class BooksRepository {
  BooksRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final BooksRepository instance = BooksRepository._();
  final Dio _dio = Dio();

  final String _googleBooksBaseUrl =
      'https://www.googleapis.com/books/v1/volumes';
  final String _key = 'AIzaSyBAWDz7i41WI-3R8pKzvLud7kt7MGZ5nEw';

  Future<List<BookModel>> fetchBooksFromApi(
      {required List<String> categories}) async {
    try {
      List<BookModel> books = [];
      for (String category in categories) {
        String url =
            '$_googleBooksBaseUrl?q=subject:$category&key=$_key';

        final response = await _dio.get(url);

        if (response.statusCode == 200) {
          var data = response.data['items'] as List;
          books.addAll(
              data.map((bookJson) => BookModel.fromJson(bookJson)).toList());
        } else {
          print('Failed to fetch books for category $category');
        }
      }
      return books;
    } catch (e) {
      print('Error fetching books from API: $e');
      return [];
    }
  }

  Future<void> saveBooksToFirebase(List<BookModel> books) async {
    try {
      final batch = _firestore.batch();
      for (var book in books) {
        DocumentReference bookRef = _firestore.collection('books').doc(book.id);
        batch.set(bookRef, book.toJson());
      }
      await batch.commit();
      print('Books saved to Firebase.');
    } catch (e) {
      print('Error saving books to Firebase: $e');
    }
  }

  Future<void> fetchAndSaveBooksToFirebase(List<String> categories) async {
    List<BookModel> booksFromApi = await fetchBooksFromApi(
        categories: categories);

    if (booksFromApi.isNotEmpty) {
      // Save books to Firebase if we have data
      await saveBooksToFirebase(booksFromApi);
    } else {
      print('No books to save.');
    }
  }

  Future<List<BookModel>> fetchBooksFromFirebase() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching books from Firebase: $e');
      return [];
    }
  }
  Future<List<BookModel>> fetchBooksByCategoryFromFirebase(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('books')
          .where('category', isEqualTo: category)  // Filter books by category
          .get();

      return querySnapshot.docs
          .map((doc) => BookModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching books by category from Firebase: $e');
    }
  }
}


/*
  // Fetch books by filter (price, title, etc.) from Firebase
  Future<List<BookModel>> fetchBooksByFilterFromFirebase(
      String field, dynamic value) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('books')
          .where(field, isEqualTo: value)
          .get();
      List<BookModel> books = querySnapshot.docs
          .map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return books;
    } catch (e) {
      print('Error fetching books by filter from Firebase: $e');
      return [];
    }
  }
*/

