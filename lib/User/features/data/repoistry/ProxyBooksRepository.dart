import '../models/BookModel.dart';
import 'BooksRepo.dart';

class ProxyBooksRepository implements BooksRepository {
  final BooksRepository realBooksRepository;
  List<BookModel>? cachedBooks;

  ProxyBooksRepository(this.realBooksRepository);

  @override
  Future<List<BookModel>> fetchBooksFromApi({required List<String> categories}) async {
    return await realBooksRepository.fetchBooksFromApi(categories: categories);
  }

  @override
  Future<void> saveBooksToFirebase(List<BookModel> books) async {
    await realBooksRepository.saveBooksToFirebase(books);
  }

  @override
  Future<List<BookModel>> fetchBooksFromFirebase() async {
    cachedBooks ??= await realBooksRepository.fetchBooksFromFirebase();
    return cachedBooks!;
  }

  @override
  Future<List<BookModel>> fetchBooksByCategoryFromFirebase(String category) async {
    return await realBooksRepository.fetchBooksByCategoryFromFirebase(category);
  }
}
