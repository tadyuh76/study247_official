import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';

class MonthlyStatistics extends StatelessWidget {
  final UserModel user;
  const MonthlyStatistics({super.key, required this.user});

  Color _getTileColor(double value) {
    if (value >= 1) return Palette.complete.withOpacity(1);
    if (value >= 0.8) return Palette.complete.withOpacity(0.8);
    if (value >= 0.6) return Palette.complete.withOpacity(0.6);
    if (value >= 0.4) return Palette.complete.withOpacity(0.4);
    if (value == 0) return Palette.complete.withOpacity(0);
    return Palette.complete.withOpacity(0.2);
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
            "Thống kê tháng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          SizedBox(
            height: 340,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                final now = DateTime.now();

                final willPrevYear = (now.month - index) <= 0;
                final newYear = now.year - (willPrevYear ? 1 : 0);
                final newMonth =
                    willPrevYear ? (now.month - index) + 12 : now.month - index;

                return _renderMonthCalendar(
                  user.commitBoard,
                  newYear,
                  newMonth,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderMonthCalendar(
    Map<String, Map<String, List<int>>> commitBoard,
    int year,
    int month,
  ) {
    final now = DateTime.now();

    final firstDayIndex = DateTime(year, month, 1, 1).weekday;
    final blankDays = firstDayIndex - 1;
    final renderData = [
      ...List.generate(blankDays + 7, (_) => -1),
      ...commitBoard[year.toString()]![month.toString()]!
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.chevron_left,
                color: month > now.month - 5 ? Palette.black : Palette.grey,
                size: 24,
              ),
              Text(
                "THÁNG $month",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Palette.black,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: month < now.month ? Palette.black : Palette.grey,
                size: 24,
              )
            ],
          ),
          const SizedBox(height: 10),
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
                final isToday = dayNumber == now.day && month == now.month;
                final isFuture = dayNumber > now.day && month == now.month;

                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: "${(renderData[index] / 60).toStringAsFixed(1)}h",
                  child: Container(
                    decoration: BoxDecoration(
                      border: isToday
                          ? Border.all(color: Palette.complete, width: 2)
                          : null,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: _getTileColor(renderData[index] /
                          Constants.minutesToMaxOpacityCalendar),
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isFuture
                              ? Palette.grey
                              : isEmpty
                                  ? Palette.darkGrey
                                  : Palette.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Center _renderWeekdays(int index) {
    return Center(
      child: Text(
        weekdayMap[index],
        style: const TextStyle(
          color: Palette.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
