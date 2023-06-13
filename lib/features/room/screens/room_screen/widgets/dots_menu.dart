import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/features/room/screens/room_screen/widgets/expanded_menu.dart';

class DotsMenu extends StatefulWidget {
  const DotsMenu({
    super.key,
  });

  @override
  State<DotsMenu> createState() => _DotsMenuState();
}

class _DotsMenuState extends State<DotsMenu> {
  bool expanding = false;

  void _showExpandedMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExpandedMenu(onHideMenu: onHideMenu),
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      useSafeArea: true,
    );
    expanding = true;
    setState(() {});
  }

  void onHideMenu() {
    globalKey.currentState!.context.pop();
    expanding = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return expanding
        ? const SizedBox.shrink()
        : SizedBox(
            width: 60,
            child: BlackBackgroundButton(
              onTap: () => _showExpandedMenu(context),
              child: SvgPicture.asset(
                IconPaths.more,
                color: Palette.white,
                width: 32,
                height: 32,
              ),
            ),
          );
  }
}
