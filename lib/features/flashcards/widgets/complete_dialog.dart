import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:study247/constants/common.dart';

class CompleteDiaglog extends StatelessWidget {
  final VoidCallback hideDialog;
  const CompleteDiaglog({super.key, required this.hideDialog});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Lottie.asset(
            "assets/lotties/complete.json",
            animate: true,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
