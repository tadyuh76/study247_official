import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';

class UserStreak extends StatelessWidget {
  final UserModel user;
  const UserStreak({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius:
            BorderRadius.all(Radius.circular(Constants.defaultBorderRadius)),
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chuỗi ngày học liên tiếp",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                IconPaths.streak,
                width: 120,
                height: 120,
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Palette.lightGrey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.defaultBorderRadius)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Chuỗi hiện tại",
                          style: TextStyle(color: Palette.darkGrey),
                        ),
                        Text(
                          user.currentStreak.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.primary,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Constants.defaultPadding),
                  Container(
                    decoration: const BoxDecoration(
                      color: Palette.lightGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Constants.defaultBorderRadius),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Chuỗi dài nhất",
                          style: TextStyle(color: Palette.darkGrey),
                        ),
                        Text(
                          user.longestStreak.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.black,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Constants.defaultPadding),
          const Text(
            "Học 15 phút mỗi ngày trong các phòng học để tiếp tục ngọn lửa này nhé!",
            style: TextStyle(color: Palette.darkGrey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
