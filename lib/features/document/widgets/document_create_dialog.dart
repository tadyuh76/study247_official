import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/color_picker.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/text_input.dart';
import 'package:study247/utils/show_snack_bar.dart';

class DocumentCreateDialog extends ConsumerStatefulWidget {
  const DocumentCreateDialog({super.key});

  @override
  ConsumerState<DocumentCreateDialog> createState() =>
      _DocumentCreateDialogState();
}

class _DocumentCreateDialogState extends ConsumerState<DocumentCreateDialog> {
  bool _isCreatingFolder = false;
  int _selectingColorIdx = 0;
  String get _selectedColor => bannerColors.keys.toList()[_selectingColorIdx];
  final _folderNameController = TextEditingController();

  void _createNewDocument(BuildContext context) {
    ref.read(documentControllerProvider.notifier).createNewDocument(context);
  }

  void _createNewFolder(BuildContext context) {
    final folderName = _folderNameController.text.trim();
    if (folderName.isEmpty) {
      showSnackBar(context, "Tên thư mục không được bỏ trống!");
      return;
    }

    ref.read(documentControllerProvider.notifier).createNewFolder(
          context,
          color: _selectedColor,
          name: folderName,
        );
  }

  void _displayFolderSettings() {
    setState(() => _isCreatingFolder = true);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            margin: const EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: _isCreatingFolder
                ? _renderFolderSettings(context)
                : _renderBaseContent(context),
          ),
        ),
      ),
    );
  }

  Column _renderFolderSettings(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Tạo mới",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: Constants.defaultPadding),
        AppTextInput(
          title: "Tên thư mục",
          hintText: "VD: Lý Chương I",
          controller: _folderNameController,
          onEditingComplete: () {},
        ),
        const SizedBox(height: Constants.defaultPadding * 2),
        const InputTitle(title: "Màu thư mục"),
        const SizedBox(height: Constants.defaultPadding / 2),
        ColorPicker(
          onSelect: (index) => setState(() => _selectingColorIdx = index),
          selectingColorIdx: _selectingColorIdx,
        ),
        const SizedBox(height: Constants.defaultPadding),
        CustomButton(
          text: "Tạo thư mục",
          onTap: () => _createNewFolder(context),
        ),
      ],
    );
  }

  Column _renderBaseContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Tạo mới",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: Constants.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _renderCreateButton(
              iconName: Icons.edit_document,
              title: "Tài liệu",
              onTap: () => _createNewDocument(context),
            ),
            const SizedBox(width: Constants.defaultPadding / 2),
            _renderCreateButton(
              iconName: Icons.folder,
              title: "Thư mục",
              onTap: _displayFolderSettings,
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
      ],
    );
  }

  Column _renderCreateButton({
    required IconData iconName,
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
                child: Icon(
                  iconName,
                  size: 64,
                  color: Palette.darkGrey,
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
