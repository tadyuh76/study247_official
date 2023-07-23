import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:study247/features/timer/notifiers/room_timer.dart';
import 'package:study247/features/timer/providers/timer_type.dart';
import 'package:study247/utils/format_time.dart';

class BreaktimeDialog extends ConsumerStatefulWidget {
  const BreaktimeDialog({super.key});

  @override
  ConsumerState<BreaktimeDialog> createState() => _BreaktimeDialogState();
}

class _BreaktimeDialogState extends ConsumerState<BreaktimeDialog> {
  bool _started = false;

  Future<void> _onStart() async {
    if (_started) return;

    final timerType = ref.read(timerTypeProvider);
    if (timerType == TimerType.room) {
      ref.read(roomTimerProvider.notifier)
        ..startBreaktime()
        ..updateTimer();
    } else {
      ref.read(personalTimerProvider.notifier)
        ..startBreaktime()
        ..updateTimer();
    }

    context.pop();
    setState(() => _started = true);
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      title: "Đến lúc nghỉ ngơi rồi!",
      iconPath: IconPaths.timer,
      child: Column(
        children: [
          const SizedBox(height: Constants.defaultBorderRadius),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.lightGrey,
            ),
            child: SvgPicture.asset(
              IconPaths.coffee,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(height: Constants.defaultPadding),
          Consumer(builder: (context, ref, child) {
            final timerType = ref.read(timerTypeProvider);
            late int remainTime;

            if (timerType == TimerType.room) {
              remainTime = ref.watch(roomTimerProvider).remainTime;
            } else {
              remainTime = ref.watch(personalTimerProvider).remainTime;
            }

            // if (remainTime == 0) context.pop();

            return Text(
              formatTime(remainTime),
              style: TextStyle(
                fontSize: 24,
                color: _started ? Palette.primary : Palette.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          const SizedBox(height: Constants.defaultPadding),
          CustomButton(
            text: "Xác nhận",
            onTap: _onStart,
            primary: true,
          ),
        ],
      ),
    );
  }
}
