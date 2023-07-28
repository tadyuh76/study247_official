import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class CustomButton extends StatelessWidget {
  final bool primary;
  final Color? color;
  final String text;
  final VoidCallback onTap;
  final bool loading;
  final bool disabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.disabled = false,
    this.primary = false,
    this.loading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: disabled
          ? Palette.grey
          : color ?? (primary ? Palette.primary : Palette.white),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: disabled ? () {} : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: Constants.defaultPadding,
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: primary ? Palette.white : Palette.primary,
                    ),
                  )
                : Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: disabled
                          ? Palette.darkGrey
                          : (primary ? Palette.white : Palette.primary),
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
