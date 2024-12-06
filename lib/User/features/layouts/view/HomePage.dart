import 'package:book_store/User/features/layouts/view/FavoritePage.dart';
import 'package:book_store/User/features/layouts/view/SearchPage.dart';
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
  void initState() {
    super.initState();
    // Fetch books only once during initialization
    context.read<BookCubit>().initializeBooks();
  }

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
        title: const Text('Book World'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const FavoritePage(),
                    ),
                    );
                  },
                  icon: const Icon(Icons.favorite,color: Colors.redAccent,)
              ),
              IconButton(
                  onPressed: (){
                    // to notification page
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const NotificationPage(),
                    ),
                    );
                  },
                  icon: const Icon(Icons.notifications,color: mainGreenColor,)
              ),
              const SizedBox(width: 10,)
            ],
          )
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
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookLoaded) {
                  final books = state.books;
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCard(book: book);
                      },
                    ),
                  );
                } else if (state is BookError) {
                  return Center(child: Text(state.error));
                } else {
                  return const Center(child: Text("No books available"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}