import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/session_goal.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';

class GoalWidget extends ConsumerWidget {
  final SessionGoal goal;
  const GoalWidget({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding / 2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5)
            .copyWith(right: Constants.defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Palette.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: goal.completed,
                activeColor: Palette.primary,
                onChanged: (_) {
                  ref
                      .read(sessionGoalsControllerProvider.notifier)
                      .markComplete(goal);
                }),
            Expanded(
              child: Text(
                goal.text,
                style: TextStyle(
                  color: Palette.black,
                  fontSize: 14,
                  decoration:
                      goal.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                ref
                    .read(sessionGoalsControllerProvider.notifier)
                    .deleteGoal(goal);
              },
              child: const Icon(Icons.close, color: Palette.darkGrey),
            )
          ],
        ),
      ),
    );
  }
}
