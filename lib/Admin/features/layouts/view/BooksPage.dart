import 'package:book_store/Admin/features/layouts/view/DrawerWidget.dart';
import 'package:book_store/Admin/features/layouts/view/EditBookPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Admin/features/layouts/view/BookCard.dart';
import '../manger/BooksCubit/books_admin_cubit.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book List"),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<BooksAdminCubit, BooksAdminState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
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
            return const Center(child: Text("No books available."));
          }
        },
      ),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditBookPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}