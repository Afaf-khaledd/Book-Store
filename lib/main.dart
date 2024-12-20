import 'package:book_store/Admin/features/layouts/manger/BooksCubit/books_admin_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/CategoryCubit/category_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/DashboardCubit/dashboard_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/OrdersCubit/orders_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/ReviewsACubit/reviews_admin_cubit.dart';
import 'package:book_store/Admin/features/layouts/manger/UserACubit/user_admin_cubit.dart';
import 'package:book_store/User/features/layouts/manger/BookCubit/book_cubit.dart';
import 'package:book_store/User/features/layouts/manger/CartCubit/cart_cubit.dart';
import 'package:book_store/User/features/layouts/manger/CategoryUCubit/category_u_cubit.dart';
import 'package:book_store/User/features/layouts/manger/ReviewCubit/review_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/ServiceLocator.dart';
import 'User/features/layouts/manger/AuthCubit/auth_cubit.dart';
import 'User/features/layouts/view/SplashScreen.dart';
import 'constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
        BlocProvider<BookCubit>(
          create: (_) => getIt<BookCubit>()..initializeBooks()..fetchBooksByCategory("0rDUsmLye5yyBShe2J6U"),
        ),
        BlocProvider<CartCubit>(
          create: (_) => getIt<CartCubit>(),
        ),
        BlocProvider<ReviewCubit>(
          create: (_) => getIt<ReviewCubit>(),
        ),
        BlocProvider<CategoryCubit>(
          create: (_) => getIt<CategoryCubit>()..fetchCategories(),
        ),
        BlocProvider<BooksAdminCubit>(
          create: (_) => getIt<BooksAdminCubit>()..fetchBooks(),
        ),
        BlocProvider<OrdersCubit>(
          create: (_) => getIt<OrdersCubit>()..fetchOrders(),
        ),
        BlocProvider<ReviewsAdminCubit>(
          create: (_) => getIt<ReviewsAdminCubit>()..loadReviews(),
        ),
        BlocProvider<UserAdminCubit>(
          create: (_) => getIt<UserAdminCubit>(),
        ),
        BlocProvider<DashboardCubit>(
          create: (_) => getIt<DashboardCubit>()..fetchDashboardData(),
        ),
        BlocProvider<CategoryUCubit>(
          create: (_) => getIt<CategoryUCubit>()..fetchCategories(),
        ),
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: appBGColor,
        focusColor: mainGreenColor,
        primaryColor: mainGreenColor
      ),
      home: const SplashPage(),
    ),
    );
  }
}
