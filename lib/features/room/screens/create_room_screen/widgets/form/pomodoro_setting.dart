import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';

class PomodoroSetting extends StatelessWidget {
  final void Function(String?) onTap;
  const PomodoroSetting({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle(title: 'Pomodoro nhóm'),
        const SizedBox(height: Constants.defaultPadding / 2),
      ],
    );
  }
}
