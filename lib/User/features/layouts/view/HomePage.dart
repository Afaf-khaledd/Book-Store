import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:book_store/User/features/layouts/view/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../manger/BookCubit/book_cubit.dart';
import '../manger/BookSortingFactory.dart';
import 'BookCard.dart';
import 'NotificationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<BookCubit>().state is! BookLoaded) {
      context.read<BookCubit>().initializeBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book World',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: (){
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => NotificationPage(userId: currentUser.uid),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to view notifications.')),
                  );
                }
              },
              icon: const Icon(Icons.notifications,color: mainGreenColor,size: 27,)
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 11),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        labelText: "Search",
                        enabled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SearchPage(),
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.sort,
                    color: mainGreenColor,
                    size: 30,
                  ),
                  onSelected: (value) {
                    final bookCubit = context.read<BookCubit>();
                    final sortingStrategy = BookSortingFactory.createSortingStrategy(value);
                    bookCubit.applySorting(sortingStrategy);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'Title',
                      child: Row(
                        children: [
                          Icon(Icons.title, color: mainGreenColor),
                          SizedBox(width: 8),
                          Text("Sort by Title"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Price',
                      child: Row(
                        children: [
                          Icon(Icons.attach_money, color: mainGreenColor),
                          SizedBox(width: 8),
                          Text("Sort by Price"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Popularity',
                      child: Row(
                        children: [
                          Icon(Icons.star, color: mainGreenColor),
                          SizedBox(width: 8),
                          Text("Sort by Popularity"),
                        ],
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
            const SizedBox(height: 20,),

            BlocBuilder<BookCubit, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: NewLoadingIndicator());
                } else if (state is BookLoaded) {
                  final books = state.books;
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCard(
                          book: book,
                        );
                      },
                    ),
                  );
                } else if (state is BookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 50.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 20.0),
                        Text(state.error),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "It looks like we don't have any books at the moment. Please check back later.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 50.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "No books available",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "It looks like we don't have any books at the moment. Please check back later.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}