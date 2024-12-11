import 'package:book_store/Admin/features/layouts/view/DrawerWidget.dart';
import 'package:book_store/Admin/features/layouts/view/EditBookPage.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../User/features/data/models/BookModel.dart';
import '../manger/BooksCubit/books_admin_cubit.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Books'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<BooksAdminCubit, BooksAdminState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LowStockBooksLoaded) {
            final books = state.lowStockBooks;
            if (books.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No books with low stock!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'All books are sufficiently stocked.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipOval(
                        child: book.thumbnail != null && book.thumbnail!.isNotEmpty
                            ? Image.network(
                          book.thumbnail!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _placeholderAvatar(book),
                        )
                            : _placeholderAvatar(book),
                      ),
                      title: Text(
                        book.title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Availability: ${book.availability}',
                        style: TextStyle(
                          fontSize: 16,
                          color: book.availability! < 5
                              ? Colors.redAccent
                              : Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookPage(book: book),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );

          } else if (state is BookError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      drawer: const DrawerWidget(),
    );
  }
  Widget _placeholderAvatar(BookModel book) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: mainGreenColor,
      child: Text(
        book.title!.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
