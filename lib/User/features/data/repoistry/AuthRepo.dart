import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<UserModel?> get currentUser async{
    User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists) {
        return UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          username: doc['username'] ?? '',
          phone: doc['phone'] ?? '',
          address: doc['address'] ?? '',
          birthday: doc['birthday'] ?? '',
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    return null;
  }
  Future<User?> signUp(UserModel userModel, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: userModel.email,
      password: password,
    );

    userModel = userModel.copyWith(uid: credential.user!.uid);

    await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
    return credential.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
