import 'package:bloc/bloc.dart';

import '../../../../../User/features/data/models/BookModel.dart';
import '../../../data/repoistry/BooksAdminRepo.dart';

part 'books_admin_state.dart';

class BooksAdminCubit extends Cubit<BooksAdminState> {
  final BooksAdminRepository bookRepository;
  BooksAdminCubit(this.bookRepository) : super(BooksAdminInitial());

  void fetchBooks() async {
    emit(BookLoading());
    try {
      final books = await bookRepository.fetchBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError("Failed to fetch books"));
    }
  }

  void addBook(BookModel book) async {
    emit(BookLoading());
    try {
      await bookRepository.addBook(book);
      fetchBooks();
    } catch (e) {
      emit(BookError("Failed to add book"));
    }
  }

  void updateBook(BookModel book) async {
    emit(BookLoading());
    try {
      await bookRepository.updateBook(book);
      fetchBooks();
    } catch (e) {
      emit(BookError("Failed to update book"));
    }
  }

  void deleteBook(String id) async {
    emit(BookLoading());
    try {
      await bookRepository.deleteBook(id);
      fetchBooks();
    } catch (e) {
      emit(BookError("Failed to delete book"));
    }
  }
}