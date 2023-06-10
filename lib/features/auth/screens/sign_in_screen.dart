import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => ref
              .read(authControllerProvider.notifier)
              .signInWithGoogle(context),
          child: const Text("Sign in with Google!"),
        ),
      ),
    );
  }
}
