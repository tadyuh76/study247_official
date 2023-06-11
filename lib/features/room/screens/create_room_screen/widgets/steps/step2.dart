import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';

class Step2 extends ConsumerWidget {
  Step2({super.key});

  final _pomodoroDurationController = TextEditingController();
  final _pomodoroBreaktimeController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        NumberInput(
          controller: _pomodoroDurationController,
          hintText: "25",
          title: "Độ dài mỗi phiên học",
          maxValue: 90,
          minValue: 20,
          interval: 5,
          onEditingComplete: () => ref
              .read(roomInfoControllerProvider)
              .updateRoomInfo(
                pomodoroDuration: int.parse(_pomodoroDurationController.text),
              ),
        ),
        const SizedBox(height: Constants.defaultPadding * 2),
        NumberInput(
          controller: _pomodoroBreaktimeController,
          hintText: "5",
          title: "Thời gian nghỉ mỗi phiên học",
          maxValue: 30,
          minValue: 5,
          interval: 5,
          onEditingComplete: () => ref
              .read(roomInfoControllerProvider)
              .updateRoomInfo(
                pomodoroBreaktime: int.parse(_pomodoroBreaktimeController.text),
              ),
        ),
      ],
    );
  }
}
