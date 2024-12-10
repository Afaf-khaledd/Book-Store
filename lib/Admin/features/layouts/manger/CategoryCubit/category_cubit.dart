import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/CategoryModel.dart';
import '../../../data/repoistry/CategoryRepository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;
  CategoryCubit(this._repository) : super(CategoryInitial());
  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to fetch categories: $e'));
    }
  }

  Future<void> addCategory(String name) async {
    try {
      await _repository.addCategory(name);
      fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  Future<void> updateCategory(String id, String name) async {
    try {
      await _repository.updateCategory(id, name);
      fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      fetchCategories();
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }
}
