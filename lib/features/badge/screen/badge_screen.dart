import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/badge.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/badge/controller/badge_list_controller.dart';
import 'package:study247/utils/format_date.dart';

class BadgeScreen extends ConsumerWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesName = badgeAssetPaths.keys.toList();
    badgesName.sort((a, b) => a.compareTo(b));

    final acquiredBadges =
        ref.watch(badgeListControllerProvider).asData?.value ?? [];

    return Scaffold(
      backgroundColor: Palette.lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Palette.lightGrey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _renderHeader(),
            AspectRatio(
              aspectRatio: 1 / 2,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1 / 2,
                  crossAxisSpacing: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                ),
                itemCount: badgeAssetPaths.length,
                itemBuilder: (context, index) {
                  final curBadgeName = badgesName[index];
                  final badgePath = badgeAssetPaths[curBadgeName]!;
                  final acquired =
                      acquiredBadges.any((badge) => badge.name == curBadgeName);

                  return Tooltip(
                    showDuration: const Duration(seconds: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Palette.black.withOpacity(0.7),
                    ),
                    waitDuration: const Duration(seconds: 1),
                    triggerMode: TooltipTriggerMode.tap,
                    richMessage: WidgetSpan(
                      child: SizedBox(
                        width: 240,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                badgeTitles[curBadgeName]!,
                                style: const TextStyle(
                                  color: Palette.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                acquired
                                    ? badgeDescriptions[curBadgeName]!
                                    : "Để đạt được huy hiệu này, ${badgeDescriptions[curBadgeName]!.replaceFirst("đã", "cần")}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Palette.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              if (acquired) const SizedBox(height: 20),
                              if (acquired)
                                Text(
                                  "Đã nhận: ${formatDate(acquiredBadges.firstWhere((element) => element.name == curBadgeName).timestamp)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Palette.lightGrey,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Opacity(
                      opacity: acquired ? 1 : 0.3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(badgePath),
                          Text(
                            badgeTitles[curBadgeName]!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return const Padding(
      padding: EdgeInsets.all(Constants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Huy hiệu",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            "Thành quả những giờ học chăm chỉ của bạn!",
            style: TextStyle(color: Palette.darkGrey),
          ),
          // SizedBsox(height: 10),
        ],
      ),
    );
  }
}
