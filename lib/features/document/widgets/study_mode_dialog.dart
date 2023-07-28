import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';

enum StudyMode { longterm, speedrun }

class StudyModeDialog extends ConsumerStatefulWidget {
  const StudyModeDialog({super.key});

  @override
  ConsumerState<StudyModeDialog> createState() => _StudyModeDialogState();
}

class _StudyModeDialogState extends ConsumerState<StudyModeDialog> {
  late String _defaultStudyMode;
  String _selectingMode = StudyMode.longterm.name;
  bool _updating = false;

  bool get _editted => _selectingMode != _defaultStudyMode;
  bool get _selectingLongterm => _selectingMode == StudyMode.longterm.name;

  @override
  void initState() {
    super.initState();
    _defaultStudyMode =
        ref.read(documentControllerProvider).asData!.value!.studyMode;
    _selectingMode = _defaultStudyMode;
  }

  Future<void> _updateStudyMode() async {
    if (!_editted) return;
    setState(() => _updating = true);

    await ref
        .read(documentControllerProvider.notifier)
        .updateStudyMode(_selectingMode);
    await ref
        .read(flashcardListControllerProvider.notifier)
        .updateStudyMode(_selectingMode);

    if (mounted) context.pop();
    setState(() => _updating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Container(
            decoration: const BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Chế độ học",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: Constants.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _renderOption(
                      selecting: _selectingLongterm,
                      iconPath: IconPaths.memory,
                      title: "Ghi nhớ dài hạn",
                      onTap: () => setState(
                        () => _selectingMode = StudyMode.longterm.name,
                      ),
                    ),
                    const SizedBox(width: Constants.defaultPadding / 2),
                    _renderOption(
                      selecting: !_selectingLongterm,
                      iconPath: IconPaths.fast,
                      title: "Ôn tập nước rút",
                      onTap: () => setState(
                        () => _selectingMode = StudyMode.speedrun.name,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.defaultPadding),
                if (_selectingLongterm)
                  const Text(
                    "Tối ưu cho việc ghi nhớ kiến thức lâu dài, áp dụng thuật toán lặp lại ngắt quãng một cách chặt chẽ.",
                    style: TextStyle(fontSize: 12, color: Palette.darkGrey),
                  ),
                if (!_selectingLongterm)
                  const Text(
                    "Tối ưu cho việc ghi nhớ kiến thức nhanh trong thời gian ngắn, không giới hạn số lần ôn tập trong ngày.",
                    style: TextStyle(fontSize: 12, color: Palette.darkGrey),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Xác nhận",
                  onTap: _updateStudyMode,
                  primary: true,
                  disabled: _selectingMode == _defaultStudyMode,
                  loading: _updating,
                ),
                const SizedBox(height: 5),
                const Text(
                  "Chú ý: Thay đổi chế độ học sẽ làm mới toàn bộ dữ liệu của thẻ ghi nhớ.",
                  style: TextStyle(fontSize: 12, color: Palette.darkGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderOption({
    required bool selecting,
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: selecting ? Palette.lightGrey : Palette.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 100,
              decoration: selecting
                  ? BoxDecoration(
                      border: Border.all(color: Palette.primary, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    )
                  : null,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: iconPath == IconPaths.person ? 52 : 64,
                colorFilter: ColorFilter.mode(
                  selecting ? Palette.primary : Palette.darkGrey,
                  BlendMode.srcIn,
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
