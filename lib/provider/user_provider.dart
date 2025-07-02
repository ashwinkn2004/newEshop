import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception("User not logged in");

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();
  if (!doc.exists) throw Exception("User document does not exist");

  return doc.data()!;
});
