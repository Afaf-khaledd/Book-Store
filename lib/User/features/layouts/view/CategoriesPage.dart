import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manger/BookCubit/book_cubit.dart';
import '../manger/CategoryUCubit/category_u_cubit.dart';
import 'BookCard.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Fetch categories on init
    context.read<CategoryUCubit>().fetchCategories();
  }

  void _onCategoryLoaded(List<Map<String, dynamic>> categories) {
    if (categories.isNotEmpty && selectedCategory == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedCategory = categories.first['id'];
        });
        context.read<BookCubit>().fetchBooksByCategory(selectedCategory!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Fetch and display categories from Firebase
          BlocBuilder<CategoryUCubit, CategoryUState>(
            builder: (context, state) {
              if (state is CategoryULoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryULoaded) {
                final categories = state.categories;
                _onCategoryLoaded(categories);
                if (categories.isEmpty) {
                  return const Center(child: Text("No categories available"));
                }
                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category['id'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category['id'];
                          });
                          context.read<BookCubit>().fetchBooksByCategory(selectedCategory!);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? mainGreenColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is CategoryUError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 11),
          // Display books for the selected category
          BlocBuilder<BookCubit, BookState>(
            builder: (context, state) {
              if (state is BookLoading) {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              } else if (state is CategoryBooksLoaded) {
                if (state.category == selectedCategory) {
                  final books = state.books;
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return BookCard(book: book);
                      },
                    ),
                  );
                } else {
                  return const Expanded(child: Center(child: Text("No books available for this category")));
                }
              } else if (state is BookError) {
                return Expanded(child: Center(child: Text(state.error)));
              } else {
                return const Expanded(child: Center(child: Text("No books available")));
              }
            },
          ),
        ],
      ),
    );
  }
}
