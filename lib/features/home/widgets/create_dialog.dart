import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class RoomCreateDialog extends ConsumerStatefulWidget {
  const RoomCreateDialog({super.key});

  @override
  ConsumerState<RoomCreateDialog> createState() => _RoomCreateDialogState();
}

class _RoomCreateDialogState extends ConsumerState<RoomCreateDialog> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Container(
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Tạo phòng học",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: Constants.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _renderCreateButton(
                      iconPath: IconPaths.people,
                      title: "Phòng nhóm",
                      onTap: () => context
                        ..pop()
                        ..go("/create"),
                    ),
                    const SizedBox(width: Constants.defaultPadding / 2),
                    _renderCreateButton(
                      iconPath: IconPaths.person,
                      title: "Phòng cá nhân",
                      onTap: () => context
                        ..pop()
                        ..go("/solo"),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.defaultPadding / 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _renderCreateButton({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Palette.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: iconPath == IconPaths.person ? 52 : 64,
                  colorFilter: const ColorFilter.mode(
                    Palette.darkGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
        Text(title),
      ],
    );
  }
}
