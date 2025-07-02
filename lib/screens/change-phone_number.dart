import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../provider/user_provider.dart'; // for ref.invalidate(userInfoProvider)

class ChangePhoneNumberScreen extends ConsumerStatefulWidget {
  const ChangePhoneNumberScreen({super.key});

  @override
  ConsumerState<ChangePhoneNumberScreen> createState() =>
      _ChangePhoneNumberScreenState();
}

class _ChangePhoneNumberScreenState
    extends ConsumerState<ChangePhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPhoneController = TextEditingController();
  final TextEditingController _newPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentPhoneNumber();
  }

  Future<void> _loadCurrentPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final phoneFromFirestore = doc.data()?['phoneNumber'] as String?;
      _currentPhoneController.text = phoneFromFirestore ?? "No number set";
    }
  }

  Future<void> _updatePhoneNumber(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final newPhone = _newPhoneController.text.trim();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'phoneNumber': newPhone});

        _currentPhoneController.text = newPhone;

        ref.invalidate(userInfoProvider);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone number updated successfully")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update phone number: $e")),
        );
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
                "Change Phone Number",
                style: headingStyle.copyWith(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Update the phone number linked to your account",
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
              controller: _currentPhoneController,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: InputDecoration(
                labelText: "Current Phone Number",
                labelStyle: const TextStyle(fontFamily: "Poppins"),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(LucideIcons.phone),
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
              controller: _newPhoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: InputDecoration(
                hintText: "Enter new phone number",
                labelText: "New Phone Number",
                counterText: '',
                labelStyle: const TextStyle(fontFamily: "Poppins"),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(LucideIcons.phoneCall),
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
                  return "Please enter a phone number";
                } else if (value.trim().length != 10 ||
                    !RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                  return "Phone number must be 10 digits";
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
                onPressed: () => _updatePhoneNumber(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Update Phone Number",
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
