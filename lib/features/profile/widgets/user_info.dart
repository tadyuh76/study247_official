import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/core/shared/widgets/user_mastery_progress_bar.dart';
import 'package:study247/features/profile/widgets/update_user_dialog.dart';

class UserInfo extends StatelessWidget {
  final UserModel user;
  final bool editable;
  const UserInfo({super.key, required this.user, required this.editable});

  void _showInfoEdittingBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UpdateUserInfoDialog(user: user, key: key),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userMasteryLevel = user.getMasteryLevel();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.defaultBorderRadius),
            ),
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
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "- ${masteryTitles[userMasteryLevel]} -",
                style: const TextStyle(
                  fontSize: 12,
                  color: Palette.darkGrey,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              UserMasteryProgressBar(
                masteryLevel: userMasteryLevel,
                totalStudyTime: user.totalStudyTime,
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
              masteryLevel: userMasteryLevel,
            ),
          ),
        ),
        if (editable)
          Positioned(
            right: Constants.defaultPadding,
            top: 0,
            child: IconButton(
              splashRadius: 25,
              onPressed: () => _showInfoEdittingBox(context),
              icon: SvgPicture.asset(
                IconPaths.edit,
                colorFilter: const ColorFilter.mode(
                  Palette.darkGrey,
                  BlendMode.srcIn,
                ),
              ),
              color: Palette.darkGrey,
            ),
          ),
      ],
    );
  }
}
