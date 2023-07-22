import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class NumParticipants extends StatelessWidget {
  final int curParticipants;
  final int maxParticipants;
  const NumParticipants({
    super.key,
    required this.curParticipants,
    required this.maxParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -10,
      right: Constants.defaultPadding,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding / 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              IconPaths.people,
              width: 16,
              // color: Palette.primary,
              colorFilter: const ColorFilter.mode(
                Palette.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: Constants.defaultPadding / 2),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$curParticipants',
                    style: const TextStyle(
                      color: Palette.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '/$maxParticipants',
                    style: const TextStyle(
                      color: Palette.darkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
