import 'package:book_store/Admin/features/data/repoistry/BooksAdminRepo.dart';

import 'package:book_store/Admin/features/data/repoistry/CategoryRepository.dart';

import 'package:book_store/Admin/features/data/repoistry/DashboardRepo.dart';

import 'package:book_store/Admin/features/data/repoistry/OrderRepository.dart';

import 'package:book_store/Admin/features/data/repoistry/ReviewsAdminRepo.dart';

import 'package:book_store/Admin/features/data/repoistry/UserRepo.dart';

import 'package:book_store/Admin/features/layouts/manger/BooksCubit/books_admin_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/CategoryCubit/category_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/DashboardCubit/dashboard_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/OrdersCubit/orders_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/ReviewsACubit/reviews_admin_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/UserACubit/user_admin_cubit.dart';
import 'package:book_store/User/features/data/repoistry/BooksRepo.dart';
import 'package:book_store/User/features/data/repoistry/CategoriesURepo.dart';

import 'package:book_store/User/features/layouts/manger/BookCubit/book_cubit.dart';
import 'package:book_store/User/features/layouts/manger/CategoryUCubit/category_u_cubit.dart';
import 'package:get_it/get_it.dart';
import '../features/data/repoistry/AuthRepo.dart';
import '../features/data/repoistry/CartRepo.dart';
import '../features/data/repoistry/ProxyBooksRepository.dart';
import '../features/data/repoistry/RealBooksRepository.dart';
import '../features/data/repoistry/ReviewRepo.dart';
import '../features/layouts/manger/AuthCubit/auth_cubit.dart';
import '../features/layouts/manger/CartCubit/cart_cubit.dart';
import '../features/layouts/manger/ReviewCubit/review_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  // Books Repositories
  getIt.registerLazySingleton<BooksRepository>(() => RealBooksRepository());
  getIt.registerLazySingleton<ProxyBooksRepository>(
          () => ProxyBooksRepository(getIt<BooksRepository>()));


  getIt.registerFactory<BookCubit>(() => BookCubit(getIt<ProxyBooksRepository>()));

  getIt.registerLazySingleton<CartRepository>(() => CartRepository());
  getIt.registerFactory<CartCubit>(() => CartCubit(getIt<CartRepository>()));

  getIt.registerLazySingleton<ReviewRepository>(() => ReviewRepository());
  getIt.registerFactory<ReviewCubit>(() => ReviewCubit(getIt<ReviewRepository>()));

  getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepository());
  getIt.registerFactory<CategoryCubit>(() => CategoryCubit(getIt<CategoryRepository>()));

  getIt.registerLazySingleton<BooksAdminRepository>(() => BooksAdminRepository());
  getIt.registerFactory<BooksAdminCubit>(() => BooksAdminCubit(getIt<BooksAdminRepository>()));

  getIt.registerLazySingleton<OrderRepository>(() => OrderRepository());
  getIt.registerFactory<OrdersCubit>(() => OrdersCubit(getIt<OrderRepository>()));

  getIt.registerLazySingleton<ReviewsAdminRepository>(() => ReviewsAdminRepository());
  getIt.registerFactory<ReviewsAdminCubit>(() => ReviewsAdminCubit(getIt<ReviewsAdminRepository>()));

  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerFactory<UserAdminCubit>(() => UserAdminCubit(getIt<UserRepository>()));

  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepository());
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit(getIt<DashboardRepository>()));

  getIt.registerLazySingleton<CategoriesRepository>(() => CategoriesRepository());
  getIt.registerFactory<CategoryUCubit>(() => CategoryUCubit(getIt<CategoriesRepository>()));

}