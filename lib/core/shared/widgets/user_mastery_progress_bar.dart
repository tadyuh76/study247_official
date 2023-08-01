import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class UserMasteryProgressBar extends StatelessWidget {
  final int monthStudyTime;
  final int masteryLevel;
  const UserMasteryProgressBar({
    super.key,
    required this.monthStudyTime,
    required this.masteryLevel,
  });

  bool get _maxLevel => masteryLevel == 9;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearPercentIndicator(
          animation: true,
          backgroundColor: Palette.lightGrey,
          lineHeight: 10,
          animationDuration: 300,
          barRadius: const Radius.circular(Constants.defaultBorderRadius),
          clipLinearGradient: true,
          padding: const EdgeInsets.all(0),
          linearGradient: LinearGradient(
            colors: [
              masteryColors[masteryLevel],
              _maxLevel
                  ? masteryColors[masteryLevel]
                  : masteryColors[masteryLevel + 1]
            ],
          ),
          percent: _maxLevel
              ? 1
              : monthStudyTime / minutesToMastery[masteryLevel + 1] > 1
                  ? 1
                  : monthStudyTime / minutesToMastery[masteryLevel + 1],
          leading: Text(
            "${(monthStudyTime / 60).toStringAsFixed(1)}h ",
            style: const TextStyle(fontSize: 14),
          ),
          trailing: _maxLevel
              ? null
              : Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  message:
                      "${masteryTitles[masteryLevel + 1]} (${minutesToMastery[masteryLevel + 1] ~/ 60}h+)",
                  child: SvgPicture.asset(
                    masteryIconPaths[masteryLevel + 1],
                    width: 40,
                    height: 40,
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Text(
          _maxLevel
              ? "Bạn đã đạt cấp độ cao nhất!"
              : "Học thêm ${((minutesToMastery[masteryLevel + 1] - monthStudyTime) / 60).toStringAsFixed(1)}h để đạt cấp độ tiếp theo!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Palette.darkGrey,
          ),
        ),
      ],
    );
  }
}
