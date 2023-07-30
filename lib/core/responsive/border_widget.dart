import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';

class BorderWidget extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  const BorderWidget({
    super.key,
    required this.child,
    this.top = false,
    this.bottom = false,
    this.right = false,
    this.left = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: right
              ? const BorderSide(color: Palette.grey, width: 1)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Palette.grey, width: 1)
              : BorderSide.none,
          top: top
              ? const BorderSide(color: Palette.grey, width: 1)
              : BorderSide.none,
          bottom: bottom
              ? const BorderSide(color: Palette.grey, width: 1)
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}
