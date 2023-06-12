import 'package:flutter/material.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppLoading(),
    );
  }
}
