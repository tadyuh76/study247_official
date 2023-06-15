import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';

class DocumentWidget extends ConsumerWidget {
  final Document document;
  const DocumentWidget({
    Key? key,
    required this.document,
  }) : super(key: key);

  void _onNoteTab(BuildContext context, WidgetRef ref) {}

  void _showDocumentEditDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding / 2),
      child: Material(
        color: bannerColors[document.color],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onNoteTab(context, ref),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        document.title,
                        style: const TextStyle(
                          color: Palette.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showDocumentEditDialog(context),
                      child: SvgPicture.asset(
                        "assets/icons/more.svg",
                        width: 24,
                        height: 24,
                        color: Palette.white,
                      ),
                    )
                  ],
                ),
                // if (hasFolderName)
                //   Text(
                //     document.folderName,
                //     style: const TextStyle(fontSize: 14, color: Palette.white),
                //   ),
                const SizedBox(height: Constants.defaultPadding),
                Text(
                  document.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Palette.white, fontSize: 14),
                ),
                const SizedBox(height: Constants.defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
