import 'package:flutter/material.dart';
import 'package:study247/core/shared/widgets/app_error.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppError(),
    );
  }
}
