import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class InputTitle extends StatelessWidget {
  final String title;
  final bool optional;
  final bool centered;
  const InputTitle({
    super.key,
    required this.title,
    this.optional = false,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text(
          title.toUpperCase(),
          textAlign: centered ? TextAlign.center : null,
          style: const TextStyle(
            color: Palette.darkGrey,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: Constants.defaultPadding / 2),
        if (optional)
          const Text(
            '(Tùy chọn)',
            style: TextStyle(color: Palette.darkGrey, fontSize: 12),
          )
      ],
    );
  }
}
