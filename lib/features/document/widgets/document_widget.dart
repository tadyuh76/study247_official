import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/screens/document_control_screen.dart';
import 'package:study247/features/document/widgets/document_settings_dialog.dart';

class DocumentWidget extends ConsumerWidget {
  final Document document;
  final bool controlable;
  const DocumentWidget({
    Key? key,
    required this.document,
    required this.controlable,
  }) : super(key: key);

  void _onDocumentTap(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentControlScreen(documentId: document.id!),
      ),
    );
  }

  void _showDocumentEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DocumentSettingsDialog(document: document),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.defaultPadding / 2),
      child: Material(
        color: bannerColors[document.color],
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.defaultBorderRadius),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onDocumentTap(context, ref),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(Constants.defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_document,
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
                        document.title.isEmpty
                            ? "Chưa có tiêu đề"
                            : document.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Palette.white, fontSize: 16),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        document.folderName,
                        style: const TextStyle(
                          color: Palette.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        document.formattedStudyMode,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Palette.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Constants.defaultPadding / 2),
                GestureDetector(
                  onTap: () => _showDocumentEditDialog(context),
                  child: SvgPicture.asset(
                    IconPaths.more,
                    // color: Palette.white,
                    colorFilter: const ColorFilter.mode(
                      Palette.white,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
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
