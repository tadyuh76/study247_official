import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';

const minute = 60;

class Step2 extends ConsumerWidget {
  Step2({super.key});

  final _roomTimerDurationController = TextEditingController();
  final _roomTimerBreaktimeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ],
    );
  }
}
