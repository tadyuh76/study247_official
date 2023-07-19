import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class CustomButton extends StatelessWidget {
  final bool primary;
  final Color? color;
  final String text;
  final VoidCallback onTap;
  final bool loading;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.primary = false,
    this.loading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: Constants.defaultPadding,
        ),
        decoration: BoxDecoration(
          color: color ?? (primary ? Palette.primary : Palette.white),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Palette.white),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: primary ? Palette.white : Palette.primary,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
