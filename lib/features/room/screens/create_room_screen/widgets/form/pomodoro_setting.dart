import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';

class Step2 extends ConsumerStatefulWidget {
  const Step2({super.key});

  @override
  ConsumerState<Step2> createState() => _PomodoroSettingState();
}

class _PomodoroSettingState extends ConsumerState<Step2> {
  final _pomodoroDurationController = TextEditingController();
  final _pomodoroBreaktime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumberInput(
          controller: _pomodoroDurationController,
          hintText: "25",
          title: "Độ dài mỗi phiên học",
          onEditingComplete: () => ref
              .read(roomInfoControllerProvider)
              .updateRoomInfo(
                  pomodoroDuration:
                      int.parse(_pomodoroDurationController.text)),
          maxValue: 90,
          minValue: 25,
          interval: 5,
        ),
        const SizedBox(height: Constants.defaultPadding),
        NumberInput(
          controller: _pomodoroBreaktime,
          hintText: "5",
          title: "Thời gian nghỉ mỗi phiên học",
          onEditingComplete: () {},
          maxValue: 30,
          minValue: 5,
          interval: 5,
        ),
      ],
    );
  }
}
