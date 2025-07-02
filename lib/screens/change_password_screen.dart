import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final currentEmail = user.email!;
      final currentPassword = _currentPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      try {
        // 🔐 Re-authenticate
        final cred = EmailAuthProvider.credential(
          email: currentEmail,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);

        // ✅ Update password
        await user.updatePassword(newPassword);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'password': newPassword});

        await user.reload();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password updated successfully")),
        );

        // Clear form
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Password update failed")),
        );
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
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.12),
              Text(
                "Change Password",
                style: headingStyle.copyWith(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ensure your new password is strong",
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
      child: Column(
        children: [
          buildPasswordField(
            controller: _currentPasswordController,
            label: "Current Password",
            icon: LucideIcons.lock,
          ),
          const SizedBox(height: 24),
          buildPasswordField(
            controller: _newPasswordController,
            label: "New Password",
            icon: LucideIcons.lock,
          ),
          const SizedBox(height: 24),
          buildPasswordField(
            controller: _confirmPasswordController,
            label: "Confirm Password",
            icon: LucideIcons.lock,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please confirm your password";
              }
              if (value.trim() != _newPasswordController.text.trim()) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => _changePassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
              child: const Text(
                "Update Password",
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
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(icon),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter $label";
            }
            if (label == "New Password" && value.trim().length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
