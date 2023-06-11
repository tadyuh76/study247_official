import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: Constants.defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Palette.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
