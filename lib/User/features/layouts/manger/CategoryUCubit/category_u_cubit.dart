import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/repoistry/CategoriesURepo.dart';

part 'category_u_state.dart';

class CategoryUCubit extends Cubit<CategoryUState> {
  final CategoriesRepository _repository;
  Map<String, String> _categoriesMap = {}; // Map of category ID to name

  CategoryUCubit(this._repository) : super(CategoryUInitial());

  void fetchCategories() async {
    emit(CategoryULoading());
    try {
      final categories = await _repository.fetchCategories();
      _categoriesMap = {
        for (var category in categories) category['id']: category['name']
      };
      emit(CategoryULoaded(categories: categories));
    } catch (e) {
      emit(CategoryUError(message: e.toString()));
    }
  }

  String getCategoryName(String categoryId) {
    return _categoriesMap[categoryId] ?? 'Unknown';
  }
}