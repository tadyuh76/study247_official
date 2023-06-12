import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/widgets/black_background_button.dart';
import 'package:study247/features/room_timer/controllers/room_timer_controller.dart';
import 'package:study247/features/room_timer/providers/remain_time_provider.dart';
import 'package:study247/features/room_timer/widgets/room_timer_box.dart';
import 'package:study247/utils/format_time.dart';

class RoomTimerTab extends ConsumerWidget {
  const RoomTimerTab({
    super.key,
  });

  void _showRoomTimerBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RoomTimerBox(
        hideBox: Navigator.of(context).pop,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: the timer only run when I init the controller
    ref.read(roomTimerControllerProvider);
    final remainTime = ref.watch(remainTimeProvider);

    return BlackBackgroundButton(
      onTap: () => _showRoomTimerBox(context),
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
              const Text(
                "Tập trung",
                style: TextStyle(
                  color: Palette.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            formatTime(remainTime),
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
