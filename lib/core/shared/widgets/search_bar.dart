import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, required this.hintText});
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      decoration: const BoxDecoration(
        color: Palette.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14, color: Palette.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                isDense: true,
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Palette.darkGrey, fontSize: 14),
              ),
            ),
          ),
          // const SizedBox(width: 10),
          SvgPicture.asset(
            IconPaths.search,
            colorFilter:
                const ColorFilter.mode(Palette.darkGrey, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
