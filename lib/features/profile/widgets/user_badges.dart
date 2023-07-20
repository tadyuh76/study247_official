import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';

class UserBadges extends StatelessWidget {
  final UserModel user;
  const UserBadges({super.key, required this.user});

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
            "Huy hiệu của tôi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    IconPaths.clock2,
                    width: 60,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}