import 'dart:math';

import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';

const double baseHeight = 120; // equals to a figure of 6 hours
const double maxCrossAxis = 2; // hours
const double textSize = 25;

class WeeklyStatistics extends StatelessWidget {
  final UserModel user;
  const WeeklyStatistics({super.key, required this.user});

  double get _maxCrossAxis {
    int maxMinutes = 0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final curDay = now.subtract(Duration(days: i));
      final curYearData = user.commitBoard[curDay.year.toString()]!;
      final curMonthData = curYearData[curDay.month.toString()]!;
      maxMinutes = max(maxMinutes, curMonthData[curDay.day - 1]);
    }
    final maxHours = maxMinutes / 60;
    final maxCrossAxis = maxHours.round();
    return maxCrossAxis >= 2 ? maxCrossAxis * 1.0 : 2;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius:
            BorderRadius.all(Radius.circular(Constants.defaultBorderRadius)),
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thống kê 7 ngày gần đây",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: baseHeight + textSize + 10,
                      // to avoid the bottom axis
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _renderChartBackground(_maxCrossAxis),
                          _renderChartBackground(_maxCrossAxis * 3 / 4),
                          _renderChartBackground(_maxCrossAxis * 2 / 4),
                          _renderChartBackground(_maxCrossAxis * 1 / 4),
                          _renderChartBase(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(width: 20), // to avoid the left axis

                        ...List.generate(7, (index) => index)
                            .reversed
                            .map((index) {
                          final curDay = now.subtract(Duration(days: index));
                          final curYearData =
                              user.commitBoard[curDay.year.toString()]!;
                          final curMonthData =
                              curYearData[curDay.month.toString()]!;

                          return _renderChartFigure(
                            day: curDay.day,
                            month: curDay.month,
                            percent: curMonthData[curDay.day - 1] /
                                (60 * _maxCrossAxis),
                          );
                        })
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderChartBase() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: textSize,
        top: textSize / 2 - 2,
        left: textSize + 10 - 2,
      ),
      width: double.infinity,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(Constants.defaultBorderRadius)),
        color: Palette.primary.withOpacity(0.4),
      ),
    );
  }

  Widget _renderChartBackground(double value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (value != -1)
          SizedBox(
            height: 20,
            child: Center(
              child: Text(
                "${value}h",
                style: const TextStyle(
                  color: Palette.darkGrey,
                  height: 1.0,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 30,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Palette.grey,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.defaultBorderRadius)),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderChartFigure({
    required double percent,
    required int day,
    required int month,
  }) {
    return Tooltip(
      message: "${(percent * _maxCrossAxis).toStringAsFixed(1)}h",
      triggerMode: TooltipTriggerMode.tap,
      child: Column(
        children: [
          Container(
            height: percent * baseHeight,
            width: 10,
            decoration: const BoxDecoration(
              color: Palette.primary,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
          SizedBox(
            height: 25,
            child: Center(
              child: Text(
                "$day/$month",
                style: const TextStyle(fontSize: 12, color: Palette.darkGrey),
              ),
            ),
          )
        ],
      ),
    );
  }
}
