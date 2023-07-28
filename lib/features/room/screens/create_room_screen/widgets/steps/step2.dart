import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';

const minute = 60;

class Step2 extends ConsumerStatefulWidget {
  const Step2({super.key});

  @override
  ConsumerState<Step2> createState() => _Step2State();
}

class _Step2State extends ConsumerState<Step2> {
  final _roomTimerDurationController = TextEditingController();
  final _roomTimerBreaktimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberInput(
          controller: _roomTimerDurationController,
          hintText: "25",
          title: "Độ dài mỗi phiên học",
          maxValue: 90,
          minValue: 15,
          interval: 5,
          onEditingComplete: () =>
              ref.read(roomInfoControllerProvider).updateRoomInfo(
                    roomTimerDuration:
                        int.parse(_roomTimerDurationController.text) * minute,
                  ),
        ),
        const SizedBox(height: Constants.defaultPadding * 2),
        NumberInput(
          controller: _roomTimerBreaktimeController,
          hintText: "5",
          title: "Thời gian nghỉ mỗi phiên học",
          maxValue: 30,
          minValue: 5,
          interval: 5,
          onEditingComplete: () =>
              ref.read(roomInfoControllerProvider).updateRoomInfo(
                    roomTimerBreaktime:
                        int.parse(_roomTimerBreaktimeController.text) * minute,
                  ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const InputTitle(title: "Cho phép sử dụng Mic: "),
            Checkbox(
              value: ref.watch(roomInfoControllerProvider).room.allowMic,
              onChanged: (value) {
                ref
                    .read(roomInfoControllerProvider)
                    .updateRoomInfo(allowMic: value);
                setState(() {});
              },
              activeColor: Palette.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(color: Palette.darkGrey, width: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const InputTitle(title: "Cho phép sử dụng Camera: "),
            Checkbox(
              value: ref.watch(roomInfoControllerProvider).room.allowCamera,
              onChanged: (value) {
                ref
                    .read(roomInfoControllerProvider)
                    .updateRoomInfo(allowCamera: value);
                setState(() {});
              },
              activeColor: Palette.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(color: Palette.darkGrey, width: 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
