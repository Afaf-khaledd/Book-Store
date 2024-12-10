part of 'books_admin_cubit.dart';

abstract class BooksAdminState {}

final class BooksAdminInitial extends BooksAdminState {}

class BookLoading extends BooksAdminState {}

class BookLoaded extends BooksAdminState {
  final List<BookModel> books;

  BookLoaded(this.books);
}

class BookError extends BooksAdminState {
  final String message;

  BookError(this.message);
}