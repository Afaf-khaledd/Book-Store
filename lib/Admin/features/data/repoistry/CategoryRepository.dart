import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CategoryModel.dart';

class CategoryRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromDocument(doc.data(), doc.id))
        .toList();
  }

  Future<void> addCategory(String name) async {
    await _firestore.collection('categories').add({'name': name});
  }

  Future<void> updateCategory(String id, String name) async {
    await _firestore.collection('categories').doc(id).update({'name': name});
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }
}