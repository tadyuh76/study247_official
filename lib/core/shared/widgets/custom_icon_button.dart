import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double size;
  const CustomIconButton({
    Key? key,
    required this.size,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Palette.black.withOpacity(0.7),
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: InkWell(
        splashColor: Palette.black,
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
