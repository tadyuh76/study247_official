import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';

class MasteryAvatar extends StatelessWidget {
  final double radius;
  final String photoURL;
  final int masteryLevel;
  final String? status;

  const MasteryAvatar({
    super.key,
    required this.radius,
    required this.photoURL,
    required this.masteryLevel,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(radius / 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius * 2)),
            border: Border.all(
              color: masteryColors[masteryLevel],
              width: radius / 5,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Palette.white,
            radius: radius,
            child: ClipOval(
              child: photoURL.isEmpty
                  ? SvgPicture.asset(IconPaths.defaultUser)
                  : Image.network(
                      photoURL,
                      fit: BoxFit.cover,
                      width: radius * 2,
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: -(radius / 3),
          left: 0,
          right: 0,
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message:
                "${masteryTitles[masteryLevel]} (${minutesToMastery[masteryLevel] ~/ 60}h+)",
            child: SvgPicture.asset(
              masteryIconPaths[masteryLevel],
              width: radius,
              height: radius,
            ),
          ),
        ),
        if (status != null)
          Positioned(
            bottom: radius / 10,
            right: radius / 10,
            child: Container(
              width: radius / 2,
              height: radius / 2,
              decoration: BoxDecoration(
                border: Border.all(color: Palette.white, width: radius / 16),
                shape: BoxShape.circle,
                color: userStatusColors[status],
              ),
            ),
          )
      ],
    );
  }
}
