import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/badge.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/badge.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/badge/controller/badge_list_controller.dart';

class UserBadges extends StatelessWidget {
  final UserModel user;
  final bool editable;
  const UserBadges({super.key, required this.user, required this.editable});

  void _viewAllBadges(BuildContext context) {
    context.go("/badges");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.defaultBorderRadius),
        ),
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Huy hiệu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (editable)
                GestureDetector(
                  onTap: () => _viewAllBadges(context),
                  child: const Text(
                    "Thêm",
                    style: TextStyle(
                      color: Palette.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (editable)
                const Icon(
                  Icons.chevron_right,
                  color: Palette.primary,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: Constants.defaultPadding),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Consumer(builder: (context, ref, child) {
              return editable
                  ? ref.watch(badgeListControllerProvider).when(
                        error: (err, stk) => const AppError(),
                        loading: () => const AppLoading(),
                        data: (badgeList) {
                          if (badgeList.isEmpty) {
                            return const Text(
                              "Bạn chưa có huy hiệu nào.",
                              style: TextStyle(),
                            );
                          }

                          return _renderBadgeList(badgeList);
                        },
                      )
                  : FutureBuilder(
                      future: ref
                          .read(badgeListControllerProvider.notifier)
                          .getBadgeListById(user.uid),
                      builder: (context, snapshot) =>
                          _renderBadgeList(snapshot.data ?? []),
                    );
            }),
          )
        ],
      ),
    );
  }

  ListView _renderBadgeList(List<BadgeModel> badgeList) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: badgeList.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset(
            badgeAssetPaths[badgeList[index].name]!,
            width: 60,
          ),
        );
      },
    );
  }
}
