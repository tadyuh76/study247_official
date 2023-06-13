import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';

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
              borderRadius: BorderRadius.all(Radius.circular(30)),
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
                const SizedBox(height: Constants.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(text: "Đồng ý", onTap: onAccept),
                    const SizedBox(width: Constants.defaultPadding * 2),
                    CustomButton(text: "Huỷ", onTap: context.pop),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
