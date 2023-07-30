import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';
import 'package:study247/features/profile/screens/profile_screen.dart';

class WebAppBar extends ConsumerWidget {
  final UserModel? user;
  final bool back;
  const WebAppBar({
    Key? key,
    this.user,
    this.back = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider).asData!.value!;
    final renderUser = user ?? currentUser;

    return Container(
      height: kToolbarHeight,
      color: Palette.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (back)
            IconButton(
              splashRadius: 25,
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          if (back) const SizedBox(width: 20),
          SvgPicture.asset(
            IconPaths.streak,
            width: 20,
          ),
          const SizedBox(width: 3),
          const Text(
            "Chuỗi học: ",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            renderUser.currentStreak.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: Constants.defaultPadding),
          SvgPicture.asset(
            IconPaths.clock,
            width: 20,
          ),
          const SizedBox(width: 5),
          const Text(
            "Tháng này: ",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            // total number of hours studied in the current month
            "${(renderUser.getMonthStudyTime() / 60).toStringAsFixed(1)}h",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: currentUser.uid != (user?.uid ?? "")
                ? () {}
                : () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  renderUser.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                Avatar(photoURL: renderUser.photoURL, radius: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
