import '../models/BookModel.dart';

abstract class BooksRepository {
  Future<List<BookModel>> fetchBooksFromApi({required List<String> categories});
  Future<void> saveBooksToFirebase(List<BookModel> books);
  Future<List<BookModel>> fetchBooksFromFirebase();
  Future<List<BookModel>> fetchBooksByCategoryFromFirebase(String category);
}