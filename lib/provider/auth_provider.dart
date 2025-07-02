import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 Add Firestore

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    checkLogin();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // 🔥 Add this

  Future<void> checkLogin() async {
    final box = Hive.box('authBox');
    final loggedIn = box.get('isLoggedIn', defaultValue: false);
    state = loggedIn;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final box = Hive.box('authBox');
      await box.put('isLoggedIn', true);
      state = true;
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<String?> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final user = userCredential.user;
      if (user != null) {
        // ✅ Set display name in Firebase Auth
        await user.updateDisplayName(name.trim());
        await user.reload(); // 👈 Refresh user session

        // ✅ Save user to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'password': password.trim(),
          'name': name.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'phoneNumber': '',
          'profileUrl': '',
        });

        final box = Hive.box('authBox');
        await box.put('isLoggedIn', true);
        state = true;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    final box = Hive.box('authBox');
    await box.put('isLoggedIn', false);
    state = false;
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Failed to send reset email";
    } catch (e) {
      return "Unexpected error: $e";
    }
  }
}
