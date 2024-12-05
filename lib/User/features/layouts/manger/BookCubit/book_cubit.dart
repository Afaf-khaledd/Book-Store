import 'package:bloc/bloc.dart';
import '../../../../core/SharedPreference.dart';
import '../../../data/models/BookModel.dart';
import '../../../data/models/BookSortingStrategy.dart';
import '../../../data/repoistry/BooksRepo.dart';
import '../BookSorting.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BooksRepository bookRepository;
  final BookSorter bookSorter = BookSorter();
  BookCubit(this.bookRepository) : super(BookInitial());

  // Fetch books from Firebase only after the first API call
  Future<void> initializeBooks() async {
    emit(BookLoading());

    try {
      // Fetch books from Firebase directly
      final books = await bookRepository.fetchBooksFromFirebase();

      if (books.isEmpty) {

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

        final fetchedBooks = await bookRepository.fetchBooksFromApi(categories: categories);

        if (fetchedBooks.isNotEmpty) {
          // Save books to Firebase
          await bookRepository.saveBooksToFirebase(fetchedBooks);

          emit(BookLoaded(fetchedBooks));
        } else {
          emit(BookError("No books found to save."));
        }
      } else {
        emit(BookLoaded(books));
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> fetchBooksFromFirebase() async {
    emit(BookLoading());

    try {
      final books = await bookRepository.fetchBooksFromFirebase();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> fetchBooksByCategory(String category) async {
    emit(BookLoading());
    try {
      final books = await bookRepository.fetchBooksByCategoryFromFirebase(category);

      if (books.isNotEmpty) {
        emit(CategoryBooksLoaded(books, category));
      } else {
        final fetchedBooks = await bookRepository.fetchBooksFromApi(categories: [category]);
        if (fetchedBooks.isNotEmpty) {
          await bookRepository.saveBooksToFirebase(fetchedBooks);
          emit(CategoryBooksLoaded(fetchedBooks, category));
        } else {
          emit(BookError('No books found in the category: $category.'));
        }
      }
    } catch (e) {
      emit(BookError(e.toString()));
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