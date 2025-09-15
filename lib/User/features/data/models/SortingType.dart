import 'BookModel.dart';
import 'BookSortingStrategy.dart';

class SortByTitle implements BookSortingStrategy {
  @override
  List<BookModel> sort(List<BookModel> books) {
    books.sort((a, b) => (a.title ?? "").compareTo(b.title ?? ""));
    return books;
  }
}

class SortByPrice implements BookSortingStrategy {
  @override
  List<BookModel> sort(List<BookModel> books) {
    books.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    return books;
  }
}

class SortByPopularity implements BookSortingStrategy {
  @override
  List<BookModel> sort(List<BookModel> books) {
    books.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
    return books;
  }
}