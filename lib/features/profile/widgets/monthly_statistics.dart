import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class MonthlyStatistics extends StatelessWidget {
  final UserModel user;
  const MonthlyStatistics({super.key, required this.user});

  Color _getTileColor(double value) {
    if (value >= 1) return Palette.complete.withOpacity(1);
    if (value >= 0.5) return Palette.complete.withOpacity(0.5);
    if (value == 0) return Palette.complete.withOpacity(0);
    return Palette.complete.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
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
            "Thống kê tháng này",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          Consumer(builder: (context, ref, child) {
            return ref.watch(authControllerProvider).when(
                error: (err, stk) => const AppError(),
                loading: () => const AppLoading(),
                data: (user) {
                  if (user == null) return const AppLoading();
                  final now = DateTime.now();
                  final thisYear = user.commitBoard[now.year.toString()]!;

                  return _renderMonthCalendar(thisYear);
                });
          })
        ],
      ),
    );
  }

  Widget _renderMonthCalendar(Map<String, List<int>> thisYear) {
    final now = DateTime.now();
    final thisMonth = thisYear[now.month.toString()]!;

    final firstDayIndex = DateTime(now.year, now.month, 1, 1).weekday;
    final blankDays = firstDayIndex;
    final renderData = [
      ...List.generate(blankDays + 7, (_) => -1),
      ...thisMonth
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_left,
                color: Palette.darkGrey,
              ),
            ),
            Text(
              "THÁNG ${now.month}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Palette.darkGrey,
                fontSize: 16,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_right,
                color: Palette.darkGrey,
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: renderData.length,
            itemBuilder: (context, index) {
              if (index < 7) return _renderWeekdays(index);
              if (renderData[index] == -1) return const SizedBox.shrink();

              final dayNumber = index - 7 - (blankDays - 1);
              final isEmpty = renderData[index] == 0;
              final isToday = dayNumber == now.day;

              return Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: "${(renderData[index] / 60).toStringAsFixed(1)}h",
                child: Container(
                  decoration: BoxDecoration(
                    border: isToday
                        ? Border.all(color: Palette.complete, width: 2)
                        : null,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: _getTileColor(renderData[index] / 60),
                  ),
                  child: Center(
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isEmpty ? Palette.darkGrey : Palette.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Center _renderWeekdays(int index) {
    return Center(
      child: Text(
        Constants.weekdayMap[index],
        style: const TextStyle(
          color: Palette.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
