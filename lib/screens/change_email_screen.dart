import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../provider/user_provider.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentEmail();
  }

  Future<void> _loadCurrentEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentEmailController.text = user.email ?? "No email found";
    }
  }

  Future<void> _updateEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User not logged in");

        final newEmail = _newEmailController.text.trim();
        final password = _passwordController.text.trim();

        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        // 🔐 Re-authenticate
        await user.reauthenticateWithCredential(cred);

        // ✅ Update Firebase Auth email
        await user.updateEmail(newEmail);
        await user.reload();

        // ✅ Update Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'email': newEmail});

        // ✅ Refresh UI
        _currentEmailController.text = newEmail;
        ref.invalidate(userInfoProvider);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email updated successfully")),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Update failed")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
                "Change Email",
                style: headingStyle.copyWith(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Securely update your login email",
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
              controller: _currentEmailController,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: _inputDecoration("Current Email", LucideIcons.mail),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _newEmailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: _inputDecoration("New Email", LucideIcons.mailPlus),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter a new email address";
                } else if (!RegExp(
                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                ).hasMatch(value.trim())) {
                  return "Enter a valid email address";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: _inputDecoration("Password", LucideIcons.lock),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
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
                onPressed: () => _updateEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Update Email",
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: "Poppins"),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: Colors.deepOrange),
      ),
    );
  }
}
