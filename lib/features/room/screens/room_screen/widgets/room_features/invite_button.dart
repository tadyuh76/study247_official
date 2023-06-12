import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Palette.primary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(IconPaths.addPeople, width: 20, height: 20),
          const SizedBox(width: Constants.defaultPadding / 2),
          const Text(
            "Mời",
            style: TextStyle(color: Palette.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}
