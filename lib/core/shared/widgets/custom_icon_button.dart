import 'package:flutter/material.dart';

import 'package:study247/core/palette.dart';

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double size;
  final Color backgroundColor;
  const CustomIconButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.size,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: InkWell(
        splashColor: backgroundColor,
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}
