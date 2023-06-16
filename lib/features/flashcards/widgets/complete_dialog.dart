import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';

class CompleteDiaglog extends StatelessWidget {
  final VoidCallback hideDialog;
  const CompleteDiaglog({super.key, required this.hideDialog});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Ôn tập hoàn tất!",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Lottie.asset(
                  "assets/lotties/complete.json",
                  repeat: false,
                  animate: true,
                  height: 200,
                  width: 200,
                ),
                CustomButton(text: "Trở lại", onTap: context.pop)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
