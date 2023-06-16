import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/color_picker.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/text_input.dart';

class FolderSettingsDialog extends ConsumerStatefulWidget {
  const FolderSettingsDialog({super.key, required this.folder});
  final Folder folder;

  @override
  ConsumerState<FolderSettingsDialog> createState() =>
      _DocumentSettingsDialogState();
}

class _DocumentSettingsDialogState extends ConsumerState<FolderSettingsDialog> {
  int _selectingColorIdx = 0;
  String _selectingColor = "blue";
  final _folderNameController = TextEditingController();

  @override
  void initState() {
    _selectingColor = widget.folder.color;

    for (int i = 0; i < bannerColors.length; i++) {
      if (bannerColors.keys.toList()[i] == _selectingColor) {
        _selectingColorIdx = i;
      }
    }
    _folderNameController.text = widget.folder.name;
    super.initState();
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    ref.read(documentControllerProvider.notifier).editFolder(
          widget.folder.copyWith(
            name: _folderNameController.text,
            color: bannerColors.keys.toList()[_selectingColorIdx],
          ),
        );
    if (mounted) context.pop();
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
                AppTextInput(
                  title: "Tên thư mục",
                  hintText: "Lý chương I",
                  controller: _folderNameController,
                  onEditingComplete: () {},
                ),
                const SizedBox(height: Constants.defaultPadding),
                _renderOption("Đổi màu ghi chú", IconPaths.color),
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

  Widget _renderOption(String text, String iconPath, [VoidCallback? onTap]) {
    bool canTap = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Constants.defaultPadding),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 32,
              height: 32,
              color: Palette.black,
            ),
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
