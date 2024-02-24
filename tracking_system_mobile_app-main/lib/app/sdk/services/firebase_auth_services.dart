import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  // User Login
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String message = '';
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      message = 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'user-not-found';
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        message = 'wrong-password';
        throw Exception('Wrong password provided for that user.');
      }
      return message;
    }
    return message;
  }

  // SignOut
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
