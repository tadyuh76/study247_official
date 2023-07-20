import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.all(
                Radius.circular(Constants.defaultBorderRadius)),
          ),
          padding:
              const EdgeInsets.all(Constants.defaultPadding).copyWith(top: 80),
          margin: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                user.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Người mới -",
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.darkGrey,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              LinearPercentIndicator(
                animation: true,
                backgroundColor: Palette.lightGrey,
                lineHeight: 10,
                animationDuration: 300,
                barRadius: const Radius.circular(Constants.defaultBorderRadius),
                percent: 0.7,
                padding: const EdgeInsets.all(0),
                linearGradient: LinearGradient(
                  colors: [
                    masteryColors[user.masteryLevel]!,
                    masteryColors[user.masteryLevel + 1]!.withOpacity(0.7)
                  ],
                ),
                trailing: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  message: "Trung cấp (2h+)",
                  child: SvgPicture.asset(
                    masteryIconPaths[user.masteryLevel + 1]!,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const Text(
                "Học thêm 0.3h để đạt cấp độ tiếp theo!",
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.darkGrey,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: Center(
            child: MasteryAvatar(
              radius: 40,
              photoURL: user.photoURL,
              masteryLevel: user.masteryLevel,
            ),
          ),
        ),
        Positioned(
          right: Constants.defaultPadding,
          top: 0,
          child: IconButton(
            splashRadius: 25,
            onPressed: () {},
            icon: const Icon(Icons.edit),
            color: Palette.darkGrey,
          ),
        ),
      ],
    );
  }
}
