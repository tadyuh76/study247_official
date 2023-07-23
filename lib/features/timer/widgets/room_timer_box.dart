import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/timer/notifiers/room_timer.dart';
import 'package:study247/features/timer/providers/timer_type.dart';
import 'package:study247/features/timer/widgets/personal_timer_box.dart';
import 'package:study247/utils/format_time.dart';

class RoomTimerBox extends ConsumerWidget {
  final VoidCallback hideBox;
  const RoomTimerBox({
    Key? key,
    required this.hideBox,
  }) : super(key: key);

  void _switchToPersonalTimer(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => PersonalTimerBox(hideBox: hideBox),
    );
    ref.read(timerTypeProvider.notifier).update((state) => TimerType.personal);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomTimer = ref.watch(roomTimerProvider);

    final percent = (roomTimer.remainTime - 1) / // better animation
        (roomTimer.isStudying
            ? roomTimer.roomTimerDuration
            : (roomTimer.roomTimerSessionNo) % 3 == 0
                ? (roomTimer.roomTimerBreaktime * 3)
                : roomTimer.roomTimerBreaktime);

    return FeatureDialog(
      title: roomTimer.isStudying ? "Tập trung" : "Giải lao",
      iconPath: IconPaths.timer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Constants.defaultPadding,
            ),
            child: SizedBox(
              height: 200,
              width: 200,
              child: CircularPercentIndicator(
                radius: 100,
                percent: percent < 0 ? 0 : percent,
                progressColor: Palette.primary,
                backgroundColor: Palette.lightGrey,
                lineWidth: 12,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  formatTime(roomTimer.remainTime),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.primary,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: Constants.defaultPadding),
          GestureDetector(
            onTap: () => _switchToPersonalTimer(context, ref),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.repeat),
                SizedBox(width: 5),
                Text(
                  "Chuyển sang đồng hồ cá nhân",
                  style: TextStyle(
                    fontSize: 12,
                    color: Palette.primary,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
