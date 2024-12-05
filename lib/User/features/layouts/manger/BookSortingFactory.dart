import '../../data/models/BookSortingStrategy.dart';
import '../../data/models/SortingType.dart';

class BookSortingFactory {
  static BookSortingStrategy createSortingStrategy(String sortBy) {
    switch (sortBy) {
      case 'Title':
        return SortByTitle();
      case 'Price':
        return SortByPrice();
      case 'Popularity':
        return SortByPopularity();
      default:
        throw Exception("Unknown sorting strategy");
    }
  }
}