import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';
import 'package:study247/features/profile/controller/profile_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/text_input.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:study247/utils/unfocus.dart';

class UpdateUserInfoDialog extends ConsumerStatefulWidget {
  final UserModel user;
  const UpdateUserInfoDialog({super.key, required this.user});

  @override
  ConsumerState<UpdateUserInfoDialog> createState() =>
      _UpdateUserInfoDialogState();
}

class _UpdateUserInfoDialogState extends ConsumerState<UpdateUserInfoDialog> {
  final _usernameController = TextEditingController();
  Uint8List? imageBytes;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text =
        ref.read(authControllerProvider).asData!.value!.displayName;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  bool get _pickedImage => imageBytes != null;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );

    if (result == null) return;
    if (result.files.first.bytes == null) return;

    await _cropImage(result.files.first.path!);
    imageBytes = result.files.first.bytes;
    setState(() {});
  }

  Future<void> _cropImage(String sourcePath) async {
    final result = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Palette.black,
          toolbarTitle: "Chỉnh sửa ảnh",
          toolbarWidgetColor: Palette.white,
          activeControlsWidgetColor: Palette.primary,
          dimmedLayerColor: Palette.black,
        ),
        IOSUiSettings()
      ],
    );
    if (result == null) return;

    imageBytes = await result.readAsBytes();
    setState(() {});
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.trim().isEmpty) {
      showSnackBar(context, "Tên người dùng không được bỏ trống!");
      return;
    }
    setState(() => loading = true);

    await ref.read(profileControllerProvider).updateProfile(
          super.context,
          newDisplayName: _usernameController.text.trim(),
          imageBytes: imageBytes,
        );

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      iconPath: IconPaths.profile,
      title: "Chỉnh sửa thông tin",
      child: Unfocus(
        child: Column(
          children: [
            const SizedBox(height: Constants.defaultPadding),
            _renderUpdateProfileImage(),
            const SizedBox(height: Constants.defaultPadding),
            _renderUpdateUserName(),
            const SizedBox(height: Constants.defaultPadding),
            CustomButton(
              text: "Xác nhận",
              onTap: () => _updateProfile(),
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderUpdateUserName() {
    return Column(
      children: [
        AppTextInput(
          title: "Tên",
          hintText: "Đạt Huy",
          controller: _usernameController,
          onEditingComplete: () {},
        ),
      ],
    );
  }

  Widget _renderUpdateProfileImage() {
    return _pickedImage
        ? CircleAvatar(
            radius: 50,
            backgroundImage: MemoryImage(imageBytes!),
          )
        : GestureDetector(
            onTap: _pickFile,
            child: Stack(
              children: [
                Avatar(photoURL: widget.user.photoURL, radius: 50),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.black.withOpacity(0.3),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Palette.white,
                          size: 20,
                        ),
                        Text(
                          "Đổi ảnh",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Palette.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
