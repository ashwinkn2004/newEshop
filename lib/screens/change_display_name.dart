import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../provider/user_provider.dart'; // ✅ Import your userInfoProvider

class ChangeDisplayNameScreen extends ConsumerStatefulWidget {
  const ChangeDisplayNameScreen({super.key});

  @override
  ConsumerState<ChangeDisplayNameScreen> createState() =>
      _ChangeDisplayNameScreenState();
}

class _ChangeDisplayNameScreenState
    extends ConsumerState<ChangeDisplayNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentNameController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserName();
  }

  Future<void> _loadCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final nameFromFirestore = doc.data()?['name'] as String?;
      _currentNameController.text = nameFromFirestore ?? "No name set";
    }
  }

  Future<void> _updateDisplayName(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final newName = _newNameController.text.trim();

        // ✅ Update Firebase Auth display name
        await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
        await FirebaseAuth.instance.currentUser!.reload();

        // ✅ Update Firestore name
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'name': newName});

        // ✅ Refresh local field
        _currentNameController.text = newName;

        // ✅ Invalidate to force Drawer to show latest
        ref.invalidate(userInfoProvider);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Display name updated successfully")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update name: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.12),
              Text(
                "Change Display Name",
                style: headingStyle.copyWith(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Update your name visible across the app",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Poppins", color: Colors.black54),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(8),
        ),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: _currentNameController,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: InputDecoration(
                labelText: "Current Name",
                labelStyle: const TextStyle(fontFamily: "Poppins"),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(LucideIcons.user),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _newNameController,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: InputDecoration(
                hintText: "Enter new display name",
                labelText: "New Name",
                labelStyle: const TextStyle(fontFamily: "Poppins"),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(LucideIcons.userPlus),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a new display name";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _updateDisplayName(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Update Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
