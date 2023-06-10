import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class InputTitle extends StatelessWidget {
  final String title;
  final bool optional;
  const InputTitle({
    super.key,
    required this.title,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Palette.darkGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: Constants.defaultPadding / 2),
        if (optional)
          const Text(
            '(Tùy chọn)',
            style: TextStyle(color: Palette.darkGrey),
          )
      ],
    );
  }
}