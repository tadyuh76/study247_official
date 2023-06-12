import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/room_timer/controllers/room_timer_controller.dart';
import 'package:study247/features/room_timer/providers/remain_time_provider.dart';
import 'package:study247/utils/format_time.dart';

class RoomTimerBox extends ConsumerWidget {
  final VoidCallback hideBox;
  const RoomTimerBox({
    Key? key,
    required this.hideBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainTime = ref.watch(remainTimeProvider);
    final roomTimer = ref.watch(roomTimerControllerProvider);

    return FeatureDialog(
      title: "Tập trung",
      iconPath: IconPaths.clock,
      child: SizedBox(
        width: double.infinity,
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
                  percent: remainTime / roomTimer.roomTimerDuration,
                  progressColor: Palette.primary,
                  backgroundColor: Palette.lightGrey,
                  lineWidth: 12,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: false,
                  center: Text(
                    formatTime(remainTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Palette.primary,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Constants.defaultPadding),
            // CustomButton(
            //   text: roomTimer.isStudying ? "Tạm dừng" : "Tiếp tục",
            //   onTap: () {
            //     roomTimer.isStudying
            //         ? roomTimer.stopTimer()
            //         : roomTimer.startTimer(context);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
