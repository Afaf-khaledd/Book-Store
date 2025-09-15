import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../User/features/data/models/BookModel.dart';

class BooksAdminRepository{
  final CollectionReference _bookCollection =
  FirebaseFirestore.instance.collection('books');

  Future<List<BookModel>> fetchBooks() async {
    final snapshot = await _bookCollection.get();
    return snapshot.docs
        .map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
  Future<List<BookModel>> fetchLowStockBooks() async {
    final snapshot = await _bookCollection.get();
    return snapshot.docs
        .map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((book) => book.availability! < 5)
        .toList();
  }

  Future<void> addBook(BookModel book) async {
    final docRef = _bookCollection.doc();
    book.id = docRef.id;
    await docRef.set(book.toJson());
  }

  Future<void> updateBook(BookModel book) async {
    await _bookCollection.doc(book.id).update(book.toJson());
    fetchBooks();
    fetchLowStockBooks();
  }

  Future<void> deleteBook(String id) async {
    await _bookCollection.doc(id).delete();
    fetchBooks();
    fetchLowStockBooks();
  }
}