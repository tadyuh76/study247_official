import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';

class FeatureDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final String iconPath;
  const FeatureDialog({
    Key? key,
    required this.child,
    required this.title,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding)
          .copyWith(top: kToolbarHeight + 100),
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            // width: 280,
            padding: const EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 4, color: Palette.darkGrey)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [_renderHeader(), child],
            ),
          ),
        ),
      ),
    );
  }

  Row _renderHeader() {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          color: Palette.black,
          height: 24,
          width: 24,
        ),
        const SizedBox(width: Constants.defaultPadding / 2),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        GestureDetector(
          onTap: globalKey.currentState!.context.pop,
          child: const Icon(Icons.close),
        )
      ],
    );
  }
}
