import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';

class PomodoroSetting extends StatefulWidget {
  final void Function(String?) onTap;
  const PomodoroSetting({super.key, required this.onTap});

  @override
  State<PomodoroSetting> createState() => _PomodoroSettingState();
}

class _PomodoroSettingState extends State<PomodoroSetting> {
  final _pomodoroDurationController = TextEditingController();
  final _pomodoroBreaktime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const InputTitle(title: 'Pomodoro nhóm'),
        // const SizedBox(height: Constants.defaultPadding),
        NumberInput(
          controller: _pomodoroDurationController,
          hintText: "25",
          title: "Độ dài mỗi phiên học",
          onEditingComplete: () {},
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
