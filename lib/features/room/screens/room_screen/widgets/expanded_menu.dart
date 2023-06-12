import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/music/widgets/music_box.dart';
import 'package:study247/features/room/screens/room_screen/widgets/black_background_button.dart';

class ExpandedMenu extends StatelessWidget {
  final VoidCallback onHideMenu;
  const ExpandedMenu({
    Key? key,
    required this.onHideMenu,
  }) : super(key: key);

  void _showMusicBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const MusicBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Constants.defaultPadding + kToolbarHeight,
        right: Constants.defaultPadding / 2,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            SizedBox(
              width: 60,
              child: BlackBackgroundButton(
                onTap: onHideMenu,
                child: SvgPicture.asset(
                  IconPaths.close,
                  color: Palette.white,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
            SizedBox(
              width: 60,
              child: BlackBackgroundButton(
                child: SvgPicture.asset(
                  IconPaths.music,
                  color: Palette.white,
                  width: 24,
                  height: 24,
                ),
                onTap: () => _showMusicBox(context),
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
            SizedBox(
              width: 60,
              child: BlackBackgroundButton(
                child: Icon(
                  Icons.image,
                  color: Palette.white,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
