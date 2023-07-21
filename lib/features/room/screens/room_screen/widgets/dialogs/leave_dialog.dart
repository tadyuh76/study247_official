import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class LeaveDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onAccept;
  const LeaveDialog({
    Key? key,
    required this.title,
    required this.child,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(Constants.defaultPadding + 10),
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(color: Palette.darkGrey)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Palette.black),
                ),
                const SizedBox(height: Constants.defaultPadding),
                child,
                const SizedBox(height: Constants.defaultPadding * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _renderButton("Đồng ý", onAccept),
                    const SizedBox(width: Constants.defaultPadding * 2),
                    _renderButton("Huỷ", context.pop),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Palette.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
