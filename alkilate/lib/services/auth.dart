import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:alkilate/services/firestore.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      // Check if the user exists in Firestore and create a document if not
      await _firestoreService
          .checkAndCreateUserDocument(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      // Handle error
      print('Firebase Auth Error: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
