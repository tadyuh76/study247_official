import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:study247/features/timer/providers/timer_type.dart';
import 'package:study247/features/timer/widgets/room_timer_box.dart';
import 'package:study247/utils/format_time.dart';

class PersonalTimerBox extends ConsumerWidget {
  final VoidCallback hideBox;
  PersonalTimerBox({
    Key? key,
    required this.hideBox,
  }) : super(key: key);

  final _roomTimerDurationController = TextEditingController();
  final _roomTimerBreaktimeController = TextEditingController();

  void _switchToRoomTimer(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => RoomTimerBox(hideBox: hideBox),
    );
    ref.read(timerTypeProvider.notifier).update((state) => TimerType.room);
  }

  void _onSubmit(WidgetRef ref) {
    final personalTimer = ref.read(personalTimerProvider);
    personalTimer.updateTimer(
      personalTimerDuration: int.parse(_roomTimerDurationController.text) * 60,
      personalTimerBreaktime:
          int.parse(_roomTimerBreaktimeController.text) * 60,
      personalTimerStart: DateTime.now().toString(),
    );
    personalTimer.initialize();
    personalTimer.setup();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalTimer = ref.watch(personalTimerProvider);
    if (!personalTimer.init) return _renderPersonalTimerSettings(ref);

    final percent = (personalTimer.remainTime - 1) / // better animation
        (personalTimer.isStudying
            ? personalTimer.personalTimerDuration
            : (personalTimer.personalTimerSessionNo) % 3 == 0
                ? (personalTimer.personalTimerBreaktime * 3)
                : personalTimer.personalTimerBreaktime);

    return FeatureDialog(
      title: personalTimer.isStudying
          ? "Tập trung (Cá nhân)"
          : "Giải lao (Cá nhân)",
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
                percent: percent,
                progressColor: Palette.primary,
                backgroundColor: Palette.lightGrey,
                lineWidth: 12,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  formatTime(personalTimer.remainTime),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PlayPauseButton(),
              SizedBox(width: Constants.defaultPadding / 2),
              _ResetButton(),
            ],
          ),
          const SizedBox(height: Constants.defaultPadding),
          GestureDetector(
            onTap: () => _switchToRoomTimer(context, ref),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.repeat),
                SizedBox(width: 5),
                Text(
                  "Chuyển sang đồng hồ nhóm",
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

  Widget _renderPersonalTimerSettings(WidgetRef ref) {
    return FeatureDialog(
      iconPath: IconPaths.timer,
      title: "Đồng hồ cá nhân",
      child: Column(
        children: [
          const SizedBox(height: Constants.defaultPadding),
          NumberInput(
            centered: true,
            controller: _roomTimerDurationController,
            hintText: "25",
            title: "Độ dài mỗi phiên học",
            maxValue: 90,
            minValue: 15,
            interval: 5,
            onEditingComplete: () {},
          ),
          const SizedBox(height: Constants.defaultPadding * 2),
          NumberInput(
            centered: true,
            controller: _roomTimerBreaktimeController,
            hintText: "5",
            title: "Thời gian nghỉ mỗi phiên học",
            maxValue: 30,
            minValue: 5,
            interval: 5,
            onEditingComplete: () {},
          ),
          const SizedBox(height: Constants.defaultPadding * 2),
          CustomButton(
            text: "Bắt đầu",
            onTap: () => _onSubmit(ref),
          )
        ],
      ),
    );
  }
}

class _PlayPauseButton extends ConsumerWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(personalTimerProvider).isPaused;

    return Material(
      color: Palette.primary,
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: InkWell(
        onTap: isPaused
            ? ref.read(personalTimerProvider).continueTimer
            : ref.read(personalTimerProvider).stopTimer,
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10).copyWith(left: 10),
          child: SvgPicture.asset(
            isPaused ? IconPaths.play : IconPaths.pause,
            // color: Palette.white,
            colorFilter: const ColorFilter.mode(
              Palette.white,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends ConsumerWidget {
  const _ResetButton();

  void _onReset(WidgetRef ref) {
    ref.read(personalTimerProvider).reset();
    ref.read(timerTypeProvider.notifier).update((_) => TimerType.room);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Palette.lightGrey,
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: InkWell(
        onTap: () => _onReset(ref),
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            IconPaths.reset,
            // color: Palette.black,
            colorFilter: const ColorFilter.mode(
              Palette.black,
              BlendMode.srcIn,
            ),
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
