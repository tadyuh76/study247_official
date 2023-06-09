import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/color_picker.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';

class Step3 extends ConsumerStatefulWidget {
  const Step3({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Step3State();
}

class _Step3State extends ConsumerState<Step3> {
  List<String> selectedTags = [];
  int _selectingColorIdx = 0;
  String get selectedColor => bannerColors.keys.toList()[_selectingColorIdx];

  void onTagSelect(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else if (selectedTags.length >= 3) {
      selectedTags.removeLast();
      selectedTags.add(tag);
    } else {
      selectedTags.add(tag);
    }

    ref.read(roomInfoControllerProvider).updateRoomInfo(tags: selectedTags);
    setState(() {});
  }

  void _onSelectColor(int index) {
    _selectingColorIdx = index;
    ref
        .read(roomInfoControllerProvider)
        .updateRoomInfo(bannerColor: selectedColor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle(title: 'Thẻ', optional: true),
        const SizedBox(height: Constants.defaultPadding / 2),
        _renderTagController(),
        _renderTags(),
        const SizedBox(height: Constants.defaultPadding),
        const InputTitle(title: 'Màu ảnh bìa'),
        const SizedBox(height: Constants.defaultPadding / 2),
        ColorPicker(
          selectingColorIdx: _selectingColorIdx,
          onSelect: _onSelectColor,
        ),
      ],
    );
  }

  Row _renderTagController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Text(
            'Chọn tối đa 3 thẻ để miêu tả chủ đề phòng học của bạn tốt hơn.',
            style: TextStyle(color: Palette.darkGrey, fontSize: 14),
          ),
        ),
        const SizedBox(width: Constants.defaultPadding),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: selectedTags.length.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Palette.darkGrey,
                ),
              ),
              const TextSpan(
                text: '/3',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Palette.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Wrap _renderTags() {
    return Wrap(
      children: tags.map(
        (tag) {
          final selected = selectedTags.contains(tag);

          return AnimatedContainer(
            duration: const Duration(microseconds: 200),
            child: GestureDetector(
              onTap: () => onTagSelect(tag),
              child: Container(
                padding: const EdgeInsets.all(Constants.defaultPadding / 2),
                margin: const EdgeInsets.only(
                  right: Constants.defaultPadding / 2,
                  top: Constants.defaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: selected ? Palette.primary : Palette.lightGrey,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: selected ? Palette.white : Palette.darkGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
