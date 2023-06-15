import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';

class DocumentWidget extends ConsumerWidget {
  final Document document;
  const DocumentWidget({
    Key? key,
    required this.document,
  }) : super(key: key);

  void _onNoteTab(BuildContext context, WidgetRef ref) {
    context.go("/document/${document.id}");
  }

  void _showDocumentEditDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding / 2),
      child: Material(
        color: bannerColors[document.color],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _onNoteTab(context, ref),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
              vertical: Constants.defaultPadding * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Palette.white,
                          fontSize: 18,
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
                if (document.folderName.isNotEmpty)
                  Text(
                    document.folderName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Palette.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                const SizedBox(height: Constants.defaultPadding),
                Text(
                  document.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Palette.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
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
