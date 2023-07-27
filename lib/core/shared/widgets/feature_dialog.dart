import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class FeatureDialog extends StatelessWidget {
  final Widget child;
  final String title;
  final String iconPath;
  const FeatureDialog({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final landscape = constraints.maxWidth > constraints.maxHeight;

        return Padding(
          padding: const EdgeInsets.all(kIsWeb ? 40 : Constants.defaultPadding)
              .copyWith(
            top: landscape ? Constants.defaultPadding : kToolbarHeight + 100,
          ),
          child: Align(
            alignment: kIsWeb ? Alignment.center : Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 500, maxWidth: 400),
                child: Container(
                  width: landscape && !kIsWeb ? 400 : null,
                  padding: const EdgeInsets.all(
                      kIsWeb ? 40 : Constants.defaultPadding),
                  decoration: const BoxDecoration(
                    color: Palette.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Palette.darkGrey)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _renderHeader(context),
                      const SizedBox(height: Constants.defaultPadding / 2),
                      landscape && !kIsWeb
                          ? Expanded(child: SingleChildScrollView(child: child))
                          : SizedBox(width: double.infinity, child: child)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row _renderHeader(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(Palette.black, BlendMode.srcIn),
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
          onTap: context.pop,
          child: const Icon(
            Icons.close,
            color: Palette.black,
          ),
        )
      ],
    );
  }
}
