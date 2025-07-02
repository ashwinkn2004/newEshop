import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarState {
  final File? localImage;
  final String? networkUrl;

  AvatarState({this.localImage, this.networkUrl});

  AvatarState copyWith({File? localImage, String? networkUrl}) {
    return AvatarState(
      localImage: localImage ?? this.localImage,
      networkUrl: networkUrl ?? this.networkUrl,
    );
  }
}

class AvatarNotifier extends StateNotifier<AvatarState> {
  AvatarNotifier() : super(AvatarState());

  final _picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(localImage: File(pickedFile.path));
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null || state.localImage == null) return;

    final storageRef = _storage.ref().child("avatars/${user.uid}.jpg");
    final uploadTask = await storageRef.putFile(state.localImage!);

    final downloadUrl = await uploadTask.ref.getDownloadURL();

    await _firestore.collection("users").doc(user.uid).update({
      'profileUrl': downloadUrl,
    });

    state = state.copyWith(networkUrl: downloadUrl);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avatar uploaded successfully")),
      );
    }
  }

  Future<void> removeImage(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final storageRef = _storage.ref().child("avatars/${user.uid}.jpg");
      await storageRef.delete();
    } catch (_) {
      // Ignore if file not found
    }

    await _firestore.collection("users").doc(user.uid).update({
      'profileUrl': '',
    });

    state = AvatarState(localImage: null, networkUrl: null);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Avatar removed")));
    }
  }

  Future<void> loadAvatarFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data();
      final url = data?['profileUrl'] ?? '';
      if (url.isNotEmpty) {
        state = state.copyWith(networkUrl: url);
      }
    }
  }
}

final avatarProvider = StateNotifierProvider<AvatarNotifier, AvatarState>((
  ref,
) {
  final notifier = AvatarNotifier();
  notifier.loadAvatarFromFirestore();
  return notifier;
});
