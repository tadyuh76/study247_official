import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';

class FlashcardOption extends StatelessWidget {
  final Color? color;
  final String text;
  final String interval;
  final VoidCallback onTap;

  const FlashcardOption({
    super.key,
    this.color,
    required this.text,
    required this.interval,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Palette.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "($interval)",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Palette.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
