import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/widgets/black_background_button.dart';
import 'package:study247/features/room_timer/notifiers/personal_timer.dart';
import 'package:study247/features/room_timer/notifiers/room_timer.dart';
import 'package:study247/features/room_timer/notifiers/timer_type.dart';
import 'package:study247/features/room_timer/widgets/personal_timer_box.dart';
import 'package:study247/features/room_timer/widgets/room_timer_box.dart';
import 'package:study247/utils/format_time.dart';

class RoomTimerTab extends ConsumerWidget {
  const RoomTimerTab({
    super.key,
  });

  void _showTimerBox(BuildContext context, WidgetRef ref) {
    final timerType = ref.read(timerTypeProvider);

    showDialog(
      context: context,
      builder: (context) => timerType == TimerType.room
          ? RoomTimerBox(hideBox: Navigator.of(context).pop)
          : PersonalTimerBox(hideBox: Navigator.of(context).pop),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerType = ref.watch(timerTypeProvider);
    RoomTimer? roomTimer;
    PersonalTimer? personalTimer;
    if (timerType == TimerType.room) {
      roomTimer = ref.watch(roomTimerProvider);
    } else {
      personalTimer = ref.watch(personalTimerProvider);
    }

    return BlackBackgroundButton(
      onTap: () => _showTimerBox(context, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconPaths.clock,
                width: 16,
                height: 16,
                color: Palette.white,
              ),
              const SizedBox(width: 5),
              Text(
                roomTimer == null
                    ? personalTimer!.isStudying
                        ? "Tập trung"
                        : "Giải lao"
                    : roomTimer.isStudying
                        ? "Tập trung"
                        : "Giải lao",
                style: const TextStyle(
                  color: Palette.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            formatTime(
              roomTimer == null
                  ? personalTimer!.remainTime
                  : roomTimer.remainTime,
            ),
            style: const TextStyle(
              color: Palette.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
