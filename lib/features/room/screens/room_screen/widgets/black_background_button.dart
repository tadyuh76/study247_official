import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class BlackBackgroundButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const BlackBackgroundButton({
    Key? key,
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
          height: 60,
          padding: const EdgeInsets.all(Constants.defaultPadding / 2),
          child: Center(child: child),
        ),
      ),
    );
  }
}
