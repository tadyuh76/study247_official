import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/common/loading_screen.dart';
import 'package:study247/core/home/home_screen.dart';
import 'package:study247/features/auth/controller/auth_controller.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(authControllerProvider.notifier).authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        } else if (!snapshot.hasData) {
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
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
