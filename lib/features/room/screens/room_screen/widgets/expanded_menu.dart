import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/features/document/screens/document_screen.dart';
import 'package:study247/features/music/widgets/music_box.dart';
import 'package:study247/features/room_background/widgets/room_background_box.dart';

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

  void _showRoomBackgroundBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RoomBackgroundBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onHideMenu();
        return true;
      },
      child: Column(
        children: [
          BlackBackgroundButton(
            width: 60,
            onTap: onHideMenu,
            child: SvgPicture.asset(
              IconPaths.close,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(height: 5),
          BlackBackgroundButton(
            width: 60,
            child: SvgPicture.asset(
              IconPaths.music,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            onTap: () => _showMusicBox(context),
          ),
          const SizedBox(height: 5),
          BlackBackgroundButton(
            onTap: () => _showRoomBackgroundBox(context),
            width: 60,
            child: SvgPicture.asset(
              IconPaths.image,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 5),
          BlackBackgroundButton(
            width: 60,
            child: SvgPicture.asset(
              IconPaths.documents,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    const DocumentScreen(navigateFromRoom: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
