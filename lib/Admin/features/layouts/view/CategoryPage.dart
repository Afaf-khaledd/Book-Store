import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../../data/models/CategoryModel.dart';
import '../manger/CategoryCubit/category_cubit.dart';
import 'DrawerWidget.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});
  void _showCategoryDialog(BuildContext context, CategoryCubit cubit, {CategoryModel? category}) {
    final TextEditingController controller = TextEditingController(text: category?.name ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Update Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final categoryName = controller.text;
                if (category == null) {
                  // Add new category
                  cubit.addCategory(categoryName);
                } else {
                  // Update existing category
                  cubit.updateCategory(category.id, categoryName);
                }
                Navigator.pop(context);
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return ListView.separated(
              itemCount: state.categories.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Card(
                    color: appBGColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      title: Text(
                        '${index + 1}. ${category.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              final cubit = context.read<CategoryCubit>();
                              _showCategoryDialog(context, cubit, category: category);
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<CategoryCubit>().deleteCategory(category.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No Categories'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<CategoryCubit>();
          _showCategoryDialog(context, cubit);
        },
        child: const Icon(Icons.add),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
