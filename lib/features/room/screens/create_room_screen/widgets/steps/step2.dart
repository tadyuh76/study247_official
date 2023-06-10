import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/pomodoro_setting.dart';

class Step2 extends ConsumerWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        PomodoroSetting(onTap: (oke) => "oke"),
      ],
    );
  }
}
