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
      margin: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      // padding: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      // decoration: const BoxDecoration(
      // color: Palette.white,
      // borderRadius: BorderRadius.all(Radius.circular(10)),
      //   // boxShadow: [BoxShadow(color: Palette.shadow, blurRadius: 16)],
      // ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconPaths.search,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Palette.darkGrey,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 14, color: Palette.black),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hintText,
                    hintStyle:
                        const TextStyle(color: Palette.darkGrey, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Palette.darkGrey,
            height: Constants.defaultPadding,
          )
        ],
      ),
    );
  }
}
