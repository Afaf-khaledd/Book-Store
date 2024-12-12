import 'package:cloud_firestore/cloud_firestore.dart';


class CategoriesRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID
      return data;
    }).toList();
  }

}