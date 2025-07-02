import 'package:eshop/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';
import 'signin_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);

    // Wait until state is initialized (avoids false flashes)
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: Image(image: AssetImage('assets/images/launch_logo.png'))),
            backgroundColor: Colors.white,
          );
        }

        return isLoggedIn ?  HomeScreen() : const SignInScreen();
      },
    );
  }
}
