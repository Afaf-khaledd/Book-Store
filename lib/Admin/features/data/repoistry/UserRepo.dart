import 'package:book_store/User/features/data/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> fetchUsersCount() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch user count: $e');
    }
  }
}