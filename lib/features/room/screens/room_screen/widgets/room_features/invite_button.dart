import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/invite_dialog.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    super.key,
  });

  void _showInviteDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const InviteDialog());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInviteDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              IconPaths.addPeople,
              width: 20,
              height: 20,
              color: Palette.primary,
            ),
            const SizedBox(width: Constants.defaultPadding / 2),
            const Text(
              "Mời",
              style: TextStyle(color: Palette.primary, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
