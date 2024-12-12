import 'package:book_store/User/features/data/models/NotificationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository{
  final _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchUserNotifications(String userId) async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data()))
        .toList();
  }
}