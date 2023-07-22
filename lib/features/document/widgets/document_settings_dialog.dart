import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/color_picker.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/document/screens/select_folder_screen.dart';

class DocumentSettingsDialog extends ConsumerStatefulWidget {
  const DocumentSettingsDialog({super.key, required this.document});
  final Document document;

  @override
  ConsumerState<DocumentSettingsDialog> createState() =>
      _DocumentSettingsDialogState();
}

class _DocumentSettingsDialogState
    extends ConsumerState<DocumentSettingsDialog> {
  int _selectingColorIdx = 0;
  String _selectingColor = "blue";
  String _curFolder = "";

  @override
  void initState() {
    _selectingColor = widget.document.color;
    for (int i = 0; i < bannerColors.length; i++) {
      if (bannerColors.keys.toList()[i] == _selectingColor) {
        _selectingColorIdx = i;
      }
    }
    _curFolder = widget.document.folderName;
    super.initState();
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    ref.read(documentControllerProvider.notifier).editDocument(
          widget.document.copyWith(
            folderName: _curFolder,
            color: bannerColors.keys.toList()[_selectingColorIdx],
          ),
        );
    if (mounted) context.pop();
  }

  void _selectFolder() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectFolderScreen(
          documentId: widget.document.id!,
          onTap: (folderName) => setState(() => _curFolder = folderName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
        child: Material(
          color: Palette.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Chỉnh sửa ghi chú",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Palette.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding),
                _renderOption(
                  _curFolder.isEmpty ? "Chọn thư mục" : _curFolder,
                  Icons.create_new_folder_rounded,
                  _selectFolder,
                ),
                _renderOption(
                  "Đổi màu ghi chú",
                  Icons.color_lens_rounded,
                ),
                ColorPicker(
                  selectingColorIdx: _selectingColorIdx,
                  onSelect: (index) =>
                      setState(() => _selectingColorIdx = index),
                ),
                const SizedBox(height: Constants.defaultPadding),
                CustomButton(
                  onTap: () => _onSave(context, ref),
                  text: "Xác nhận",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderOption(String text, IconData icon, [VoidCallback? onTap]) {
    bool canTap = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Constants.defaultPadding),
        child: Row(
          children: [
            // SvgPicture.asset(
            //   iconPath,
            //   width: 32,
            //   height: 32,
            // ),
            Icon(icon, size: 28),
            const SizedBox(width: Constants.defaultPadding),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                // fontWeight: FontWeight.w500,
                color: Palette.black,
              ),
            ),
            const Spacer(),
            if (canTap)
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: Palette.black,
              )
          ],
        ),
      ),
    );
  }
}
