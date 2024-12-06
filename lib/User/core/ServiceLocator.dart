import 'package:book_store/User/features/data/repoistry/BooksRepo.dart';
import 'package:book_store/User/features/layouts/manger/BookCubit/book_cubit.dart';
import 'package:get_it/get_it.dart';
import '../features/data/repoistry/AuthRepo.dart';
import '../features/data/repoistry/FavoritesRepository.dart';
import '../features/data/repoistry/ProxyBooksRepository.dart';
import '../features/data/repoistry/RealBooksRepository.dart';
import '../features/layouts/manger/AuthCubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  // Books Repositories
  getIt.registerLazySingleton<BooksRepository>(() => RealBooksRepository());
  getIt.registerLazySingleton<ProxyBooksRepository>(
          () => ProxyBooksRepository(getIt<BooksRepository>()));

  // Favorites Repository
  getIt.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());

  // Book Cubit (with ProxyBooksRepository and FavoritesRepository)
  getIt.registerFactory<BookCubit>(() => BookCubit(
    getIt<ProxyBooksRepository>(),
    getIt<FavoritesRepository>(),
  ));
}