import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/UserModel.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'username': userCredential.user!.displayName,
          'phone': userCredential.user!.phoneNumber,
        });
      }
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
}
