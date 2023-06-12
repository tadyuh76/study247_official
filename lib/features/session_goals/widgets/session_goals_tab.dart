import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/room_screen/widgets/black_background_button.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';
import 'package:study247/features/session_goals/widgets/session_goals_box.dart';

class SessionGoalsTab extends StatelessWidget {
  const SessionGoalsTab({
    super.key,
  });

  void showSessionGoalsBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SessionGoalsBox(
        hideBox: Navigator.of(context).pop,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlackBackgroundButton(
      onTap: () => showSessionGoalsBox(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                IconPaths.goal,
                width: 16,
                height: 16,
                color: Palette.white,
              ),
              const SizedBox(width: 5),
              const Text(
                "Mục tiêu",
                style: TextStyle(
                  color: Palette.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer(builder: (context, ref, child) {
            final goalList = ref.watch(sessionGoalsControllerProvider);
            final totalGoals = goalList.length;
            final completed = goalList.fold(
              0,
              (total, goal) => goal.completed ? total + 1 : total,
            );

            return Text(
              "$completed/$totalGoals",
              style: const TextStyle(
                color: Palette.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ],
      ),
    );
  }
}
