import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class BlackBackgroundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width, height;
  const BlackBackgroundButton({
    Key? key,
    this.width,
    this.height = 60,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Palette.black.withOpacity(0.7),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        splashColor: Palette.black,
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(Constants.defaultPadding / 2),
          child: Center(child: child),
        ),
      ),
    );
  }
}
