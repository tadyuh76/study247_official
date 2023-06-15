import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/palette.dart';

class FolderWidget extends StatelessWidget {
  final Folder folder;
  const FolderWidget({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.defaultPadding / 2),
      child: Material(
        color: bannerColors[folder.color],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsetsDirectional.all(Constants.defaultPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.folder,
                  color: Palette.white,
                  size: 80,
                ),
                const SizedBox(width: Constants.defaultPadding),
                Text(
                  folder.name,
                  style: TextStyle(color: Palette.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
