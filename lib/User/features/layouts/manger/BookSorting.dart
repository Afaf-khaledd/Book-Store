import '../../data/models/BookModel.dart';
import '../../data/models/BookSortingStrategy.dart';

class BookSorter {
  BookSortingStrategy? strategy;

  void setStrategy(BookSortingStrategy strategy) {
    this.strategy = strategy;
  }

  List<BookModel> sort(List<BookModel> books) {
    return strategy?.sort(books) ?? books;
  }
}