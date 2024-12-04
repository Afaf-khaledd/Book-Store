import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/SharedPreference.dart';
import '../../../data/models/BookModel.dart';
import '../../../data/repoistry/BooksRepo.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BooksRepository bookRepository;
  BookCubit(this.bookRepository) : super(BookInitial());

  Future<void> initializeBooks() async {
    emit(BookLoading());

    try {
      final isDataLoaded = await SharedPreference.instance.getDataLoaded();

      if (isDataLoaded) {
        final books = await bookRepository.fetchBooksFromFirebase();
        emit(BookLoaded(books));
        return;
      }

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
      final books = await bookRepository.fetchBooksFromApi(categories: categories);

      if (books.isNotEmpty) {
        // Save books to Firebase
        await bookRepository.saveBooksToFirebase(books);

        // Mark data as loaded
        await SharedPreference.instance.setDataLoaded(true);

        emit(BookLoaded(books));
      } else {
        emit(BookError("No books found to save."));
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
        emit(BookLoaded(books));
      } else {
        emit(BookError('No books found in the category: $category.'));
      }
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}