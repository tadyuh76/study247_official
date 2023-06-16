import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/screens/document_edit_screen.dart';
import 'package:study247/features/document/widgets/document_settings_dialog.dart';

class DocumentWidget extends ConsumerWidget {
  final Document document;
  const DocumentWidget({
    Key? key,
    required this.document,
  }) : super(key: key);

  void _onDocumentTab(BuildContext context, WidgetRef ref) {
    // context.go("/document/${document.id}");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentEditScreen(documentId: document.id!),
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
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onDocumentTab(context, ref),
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
                        document.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Palette.white, fontSize: 16),
                      ),
                      const SizedBox(height: Constants.defaultPadding / 2),
                      Text(
                        document.folderName,
                        style: const TextStyle(
                          color: Palette.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
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
                    color: Palette.white,
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
