import 'package:book_store/Admin/features/layouts/view/DrawerWidget.dart';
import 'package:book_store/Admin/features/layouts/view/EditBookPage.dart';
import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Admin/features/layouts/view/BookCard.dart';
import '../../../../constant.dart';
import '../manger/BooksCubit/books_admin_cubit.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<BooksAdminCubit>().state is! BookLoaded) {
      context.read<BooksAdminCubit>().fetchBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<BooksAdminCubit, BooksAdminState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: NewLoadingIndicator());
          } else if (state is BookLoaded) {
            final books = state.books;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookCard(
                    book: book,
                    onDelete: () {
                      context.read<BooksAdminCubit>().deleteBook(book.id!);
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditBookPage(book: book),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is BookError) {
            return Center(child: Text(state.message));
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_library_books_rounded,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Books Available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'It looks like there are no books yet. You can add one by tapping the button below.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton.extended(

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditBookPage(),
            ),
          );
        },
        backgroundColor: mainGreenColor,
        label: const Text("Add Book",style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}