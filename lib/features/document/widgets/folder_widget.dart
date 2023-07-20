import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/screens/document_folder_screen.dart';
import 'package:study247/features/document/widgets/folder_settings_dialog.dart';

class FolderWidget extends ConsumerWidget {
  final Folder folder;
  final VoidCallback? selecting;
  const FolderWidget({
    super.key,
    this.selecting,
    required this.folder,
  });

  void _onFolderTap(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentFromFolderScreen(folderName: folder.name),
      ),
    );
  }

  void _showFolderEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FolderSettingsDialog(folder: folder),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.defaultPadding / 2),
      child: Material(
        color: bannerColors[folder.color],
        borderRadius: const BorderRadius.all(
            Radius.circular(Constants.defaultBorderRadius)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: selecting ?? () => _onFolderTap(context, ref),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(Constants.defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.folder,
                  color: Palette.white,
                  size: 80,
                ),
                const SizedBox(width: Constants.defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        folder.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Palette.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Constants.defaultPadding / 2),
                GestureDetector(
                  onTap: () => _showFolderEditDialog(context),
                  child: SvgPicture.asset(
                    IconPaths.more,
                    // color: Palette.white,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Palette.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
