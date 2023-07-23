import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:study247/features/timer/widgets/personal_timer_box.dart';
import 'package:study247/utils/format_time.dart';

class SoloTimerTab extends ConsumerWidget {
  const SoloTimerTab({
    super.key,
  });

  void _showTimerBox(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PersonalTimerBox(
        hideBox: Navigator.of(context).pop,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(personalTimerProvider);

    return BlackBackgroundButton(
      width: 100,
      onTap: () => _showTimerBox(context, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconPaths.timer,
                width: 16,
                height: 16,
                // color: Palette.white,
                colorFilter: const ColorFilter.mode(
                  Palette.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                timer.isStudying ? "Tập trung" : "Giải lao",
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
            formatTime(timer.remainTime),
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
