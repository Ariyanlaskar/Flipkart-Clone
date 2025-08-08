import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/widget/simple_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        showToast("Please fill all fields");
        return null;
      }

      if (!email.contains('@')) {
        showToast("Invalid email address");
        return null;
      }

      if (password.length < 6) {
        showToast("Password must be at least 6 characters");
        return null;
      }

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.updateDisplayName(fullName);

      showToast("Signup successful", isError: false);

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      // Handle known Firebase errors
      if (e.code == 'email-already-in-use') {
        showToast("Email already in use");
      } else if (e.code == 'weak-password') {
        showToast("Weak password");
      } else if (e.code == 'invalid-email') {
        showToast("Invalid email");
      } else {
        showToast("Signup failed: ${e.message}");
      }
      return null;
    } catch (e) {
      // Handle unexpected errors
      showToast("An error occurred: ${e.toString()}");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code} | ${e.message}');
    }
    return null;

    // final cred = await _auth.signInWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      await googleSignIn.signOut(); // Clears previous session

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
