import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: const Icon(Icons.menu),
        title: const Text(
          Constants.appName,
          style: TextStyle(),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CreateCard(),
            TextButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(context),
              child: const Text("signout"),
            )
          ],
        ),
      ),
    );
  }
}
