import 'package:eshop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../provider/auth_provider.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    final errorMessage = await ref
        .read(authProvider.notifier)
        .signup(email: email, password: password, name: name);

    if (errorMessage == null) {
      // ✅ Signup successful, navigate or show success
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      // ❌ Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                "Register Account",

                style: headingStyle.copyWith(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your details or continue \nwith social media",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Poppins", color: Colors.black54),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
              buildForm(),
              SizedBox(height: getProportionateScreenHeight(20)),
              const Text(
                "By continuing you confirm that you agree \nwith our Terms and Conditions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(8),
        ),
        child: Column(
          children: [
            buildNameField(),
            SizedBox(height: getProportionateScreenHeight(20)),
            buildEmailField(),
            SizedBox(height: getProportionateScreenHeight(20)),
            buildPasswordField(),
            SizedBox(height: getProportionateScreenHeight(20)),
            buildConfirmPasswordField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: nameController,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        hintText: "Enter your name",
        hintStyle: const TextStyle(fontFamily: "Poppins"),
        labelText: "Name",
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const Icon(LucideIcons.user),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        hintText: "Enter your email",
        hintStyle: const TextStyle(fontFamily: "Poppins"),
        labelText: "Email",
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
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
      validator: (value) {
        if (value == null || value.isEmpty) return kEmailNullError;
        if (!emailValidatorRegExp.hasMatch(value)) return kInvalidEmailError;
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        hintText: "Enter your password",
        hintStyle: const TextStyle(fontFamily: "Poppins"),
        labelText: "Password",
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
      validator: (value) {
        if (value == null || value.isEmpty) return kPassNullError;
        if (value.length < 8) return kShortPassError;
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      style: const TextStyle(fontFamily: "Poppins"),
      decoration: InputDecoration(
        hintText: "Re-enter your password",
        hintStyle: const TextStyle(fontFamily: "Poppins"),
        labelText: "Confirm Password",
        labelStyle: const TextStyle(fontFamily: "Poppins"),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: const CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
      validator: (value) {
        if (value == null || value.isEmpty) return kPassNullError;
        if (value != passwordController.text) return kMatchPassError;
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await signup(); // call signup method defined below
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: const Text(
          "Sign up",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
