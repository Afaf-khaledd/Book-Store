import 'package:bloc/bloc.dart';
import '../../../data/models/BookModel.dart';
import '../../../data/models/BookSortingStrategy.dart';
import '../../../data/repoistry/ProxyBooksRepository.dart';
import '../BookSorting.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final ProxyBooksRepository bookRepository;
  final BookSorter bookSorter = BookSorter();
  List<BookModel> _books = [];


  BookCubit(this.bookRepository) : super(BookInitial());

  Future<void> initializeBooks() async {
    emit(BookLoading());
    try {
      // Fetch books from Firebase
      _books = await bookRepository.fetchBooksFromFirebase();

      if (_books.isEmpty) {
        emit(BookLoading());

        final categories = [
          "fiction",
          "nonfiction",
          "technology",
          "history",
          "science",
          "biography",
          "art",
          "romance",
          "mystery",
          "fantasy"
        ];
        final booksFromApi = await bookRepository.fetchBooksFromApi(categories: categories);

        if (booksFromApi.isNotEmpty) {
          // Save books to Firebase
          await bookRepository.saveBooksToFirebase(booksFromApi);
          emit(BookLoaded(booksFromApi));
        } else {
          emit(BookError("No books found from the API."));
        }
      } else {
        emit(BookLoaded(_books));
      }
    } catch (e) {
      emit(BookError("Error initializing books: ${e.toString()}"));
    }
  }

  Future<void> fetchBooksFromFirebase() async {
    emit(BookLoading());
    try {
      final books = await bookRepository.fetchBooksFromFirebase();
      if (books.isNotEmpty) {
        emit(BookLoaded(books));
      } else {
        emit(BookError("No books available in Firebase."));
      }
    } catch (e) {
      emit(BookError("Failed to fetch books from Firebase: ${e.toString()}"));
    }
  }

  void fetchBooksByCategory(String category) async {
    emit(BookLoading());
    try {
     final filteredBooks = _books.where((book) => book.category?.toLowerCase() == category.toLowerCase()).toList();
     emit(CategoryBooksLoaded(filteredBooks, category));
    } catch (e) {
      emit(BookError("Failed to fetch books for category: $category"));
    }
  }

  void applySorting(BookSortingStrategy strategy) {
    if (state is BookLoaded) {
      final books = (state as BookLoaded).books;
      bookSorter.setStrategy(strategy);
      final sortedBooks = bookSorter.sort(books);
      emit(BookLoaded(sortedBooks));
    }
  }
}