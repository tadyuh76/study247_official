import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/core/shared/widgets/user_mastery_progress_bar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class ParticipantInfoDialog extends StatelessWidget {
  final UserModel user;
  const ParticipantInfoDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      title: "Hồ sơ",
      iconPath: IconPaths.profile,
      child: Column(
        children: [
          MasteryAvatar(
            radius: 50,
            photoURL: user.photoURL,
            masteryLevel: user.masteryLevel,
          ),
          const SizedBox(height: 20),
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "- ${masteryTitles[user.masteryLevel]} -",
            style: const TextStyle(color: Palette.darkGrey),
          ),
          const SizedBox(height: 10),
          Consumer(
            builder: (context, ref, child) {
              final userId =
                  ref.read(authControllerProvider).asData!.value!.uid;
              final isSameUser = userId == user.uid;

              return isSameUser ? _renderProgress() : _renderAddFriend();
            },
          ),
        ],
      ),
    );
  }

  Widget _renderProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserMasteryProgressBar(
          totalStudyTime: user.totalStudyTime,
          masteryLevel: user.masteryLevel,
        ),
      ],
    );
  }

  Widget _renderAddFriend() {
    return CustomButton(
      text: "Thêm bạn",
      onTap: () {},
      primary: true,
    );
  }
}
