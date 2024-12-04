part of 'book_cubit.dart';

abstract class BookState {}

final class BookInitial extends BookState {}
final class BookLoading extends BookState {}
final class BookLoaded extends BookState {
  final List<BookModel> books;

  BookLoaded(this.books);

  @override
  List<Object?> get props => [books];
}
final class BookError extends BookState {
  final String error;
  BookError(this.error);
}

