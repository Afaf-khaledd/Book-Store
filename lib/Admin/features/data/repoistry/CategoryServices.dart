import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CategoryModel.dart';

class CategoriesRepoistry{

  Future<Set<String>> fetchUniqueCategories() async {
      final booksSnapshot = await FirebaseFirestore.instance.collection('books').get();
      final uniqueCategories = booksSnapshot.docs
          .map((doc) => doc['category'] as String)
          .toSet();
      return uniqueCategories;
  }

  Future<void> createCategoriesCollection(Set<String> uniqueCategories) async {
    final categoriesRef = FirebaseFirestore.instance.collection('categories');

    for (String category in uniqueCategories) {
      final categoryModel = CategoryModel(id: '', name: category);
      await categoriesRef.add(categoryModel.toMap());
    }
  }

  Future<Map<String, String>> mapCategoryNamesToIds() async {
    final categoriesSnapshot = await FirebaseFirestore.instance.collection('categories').get();

    final categoryMap = {
      for (var doc in categoriesSnapshot.docs)
        doc['name'] as String: doc.id
    };
    return categoryMap;
  }
  Future<void> updateBooksWithCategoryIds(Map<String, String> categoryMap) async {
    final booksRef = FirebaseFirestore.instance.collection('books');

    final booksSnapshot = await booksRef.get();

    for (var doc in booksSnapshot.docs) {
      final categoryName = doc['category'];
      final categoryId = categoryMap[categoryName];

      if (categoryId != null) {
        await booksRef.doc(doc.id).update({
          'category': categoryId,
        });
      }
    }
  }
  Future<void> migrateCategories() async {
    final uniqueCategories = await fetchUniqueCategories();
    await createCategoriesCollection(uniqueCategories);
    final categoryMap = await mapCategoryNamesToIds();
    await updateBooksWithCategoryIds(categoryMap);
  }

}