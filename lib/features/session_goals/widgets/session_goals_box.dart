import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';
import 'package:study247/features/session_goals/widgets/session_goal_widget.dart';

class SessionGoalsBox extends ConsumerWidget {
  final VoidCallback hideBox;
  SessionGoalsBox({super.key, required this.hideBox});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sessionGoalsControllerProvider);

    return FeatureDialog(
      title: "Mục tiêu",
      iconPath: IconPaths.goal,
      child: Column(
        children: [
          const SizedBox(height: Constants.defaultPadding / 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.all(Constants.defaultPadding / 2),
                    hintText: "Nhập mục tiêu",
                    hintStyle: TextStyle(color: Palette.darkGrey, fontSize: 14),
                    hintMaxLines: 1,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 1, color: Palette.darkGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(width: 2, color: Palette.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Consumer(
                builder: (context, ref, _) => GestureDetector(
                  onTap: () {
                    ref
                        .read(sessionGoalsControllerProvider.notifier)
                        .addGoal(_controller.text);
                    _controller.clear();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Palette.primary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, color: Palette.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.defaultPadding / 2),
          const GoalList()
        ],
      ),
    );
  }
}

class GoalList extends ConsumerWidget {
  const GoalList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = ref.watch(sessionGoalsControllerProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: goalList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => GoalWidget(goal: goalList[index]),
      ),
    );
  }
}
