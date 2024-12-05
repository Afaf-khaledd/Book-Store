import 'BookModel.dart';

abstract class BookSortingStrategy {
  List<BookModel> sort(List<BookModel> books);
}