import 'package:book_store/User/features/data/repoistry/BooksRepo.dart';
import 'package:book_store/User/features/layouts/manger/BookCubit/book_cubit.dart';
import 'package:get_it/get_it.dart';
import '../features/data/repoistry/AuthRepo.dart';
import '../features/layouts/manger/AuthCubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerLazySingleton<BooksRepository>(() => BooksRepository.instance);
  getIt.registerFactory<BookCubit>(() => BookCubit(getIt<BooksRepository>()));

}
