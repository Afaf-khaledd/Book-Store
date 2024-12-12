import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
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
            decoration: const InputDecoration(hintText: 'Category Name',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: mainGreenColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel',style: TextStyle(color: mainGreenColor),),
            ),
            TextButton(
              onPressed: () {
                final categoryName = controller.text;
                if (category == null) {
                  cubit.addCategory(categoryName);
                } else {
                  cubit.updateCategory(category.id, categoryName);
                }
                Navigator.pop(context);
              },
              child: Text(category == null ? 'Add' : 'Update',style: const TextStyle(color: mainGreenColor),),
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
        title: const Text('Categories',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: NewLoadingIndicator());
          } else if (state is CategoryLoaded) {
            return ListView.separated(
              itemCount: state.categories.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    title: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: mainGreenColor),
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
                );
              },
            );
          } else if (state is CategoryError) {
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
                      Icons.category_outlined,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Categories Available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'It looks like there are no categories yet. You can add one by tapping the button below.',
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
      floatingActionButton: FloatingActionButton.extended(

        onPressed: () {
          final cubit = context.read<CategoryCubit>();
          _showCategoryDialog(context, cubit);
        },
        backgroundColor: mainGreenColor,
        label: const Text("Add Category",style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add,color: Colors.white,),
      ),
      drawer: const DrawerWidget(),
    );
  }
}