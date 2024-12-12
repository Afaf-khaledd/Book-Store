part of 'category_u_cubit.dart';

@immutable
abstract class CategoryUState {}

class CategoryUInitial extends CategoryUState {}

class CategoryULoading extends CategoryUState {}

class CategoryULoaded extends CategoryUState {
  final List<Map<String, dynamic>> categories;
  CategoryULoaded({required this.categories});
}

/*class BookULoading extends CategoryUState {}

class BookULoaded extends CategoryUState {
  final List<BookModel> books;
  BookULoaded({required this.books});
}*/

class CategoryUError extends CategoryUState {
  final String message;
  CategoryUError({required this.message});
}