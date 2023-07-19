import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer(builder: (context, ref, child) {
        return ref.watch(authControllerProvider).when(
            error: (err, stk) => const AppError(),
            loading: () => const AppLoading(),
            data: (user) {
              if (user == null) return const Text("Đã có lỗi xảy ra...");

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _renderHeader(),
                  const SizedBox(height: 30),
                  _renderUserInfo(user),
                  const SizedBox(height: Constants.defaultPadding),
                  _renderBadges(),
                  const SizedBox(height: Constants.defaultPadding),
                  _renderStreak(),
                  const SizedBox(height: Constants.defaultPadding),
                  _renderWeeklyStatistic(),
                  const SizedBox(height: Constants.defaultPadding),
                ],
              );
            });
      }),
    );
  }

  Widget _renderWeeklyStatistic() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
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
          const SizedBox(height: Constants.defaultPadding * 2),
          Stack(
            children: [
              SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _renderChartBackground(),
                    _renderChartBackground(),
                    _renderChartBackground(),
                    _renderChartBackground(),
                    _renderChartBackground(),
                    _renderChartBackground(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _renderChartPercentage(0.7),
                  _renderChartPercentage(0.3),
                  _renderChartPercentage(0),
                  _renderChartPercentage(0.1),
                  _renderChartPercentage(1),
                  _renderChartPercentage(0.5),
                  _renderChartPercentage(0.3),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _renderChartBackground() {
    return SizedBox(
      height: 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 5),
            width: 10,
            decoration: const BoxDecoration(
              color: Palette.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  Widget _renderChartPercentage(double percent) {
    return Column(
      children: [
        Container(
          height: percent * 120,
          width: 20,
          decoration: const BoxDecoration(
            color: Palette.primary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "19/7",
          style: TextStyle(fontSize: 12, color: Palette.darkGrey),
        )
      ],
    );
  }

  Widget _renderStreak() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chuỗi ngày học liên tiếp",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconPaths.streak,
                width: 120,
                height: 120,
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Palette.lightGrey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      children: [
                        Text(
                          "Chuỗi hiện tại",
                          style: TextStyle(color: Palette.darkGrey),
                        ),
                        Text(
                          "2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.primary,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Constants.defaultPadding),
                  Container(
                    decoration: const BoxDecoration(
                      color: Palette.lightGrey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      children: [
                        Text(
                          "Chuỗi dài nhất",
                          style: TextStyle(color: Palette.darkGrey),
                        ),
                        Text(
                          "12",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.black,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _renderBadges() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      margin: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Huy hiệu của tôi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Constants.defaultPadding),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    IconPaths.clock2,
                    width: 60,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _renderUserInfo(UserModel user) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding:
              const EdgeInsets.all(Constants.defaultPadding).copyWith(top: 80),
          margin: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                user.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Người mới -",
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.darkGrey,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              LinearPercentIndicator(
                animation: true,
                backgroundColor: Palette.lightGrey,
                lineHeight: 10,
                animationDuration: 300,
                barRadius: const Radius.circular(10),
                percent: 0.7,
                padding: const EdgeInsets.all(0),
                linearGradient: LinearGradient(
                  colors: [
                    masteryColors[user.masteryLevel]!,
                    masteryColors[user.masteryLevel + 1]!.withOpacity(0.7)
                  ],
                ),
                trailing: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  message: "Trung cấp (2h+)",
                  child: SvgPicture.asset(
                    masteryIconPaths[user.masteryLevel + 1]!,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const Text(
                "Học thêm 0.3h để đạt cấp độ tiếp theo!",
                style: TextStyle(
                  fontSize: 12,
                  color: Palette.darkGrey,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: Center(
            child: MasteryAvatar(
              radius: 40,
              photoURL: user.photoURL,
              masteryLevel: user.masteryLevel,
            ),
          ),
        ),
        Positioned(
          right: Constants.defaultPadding,
          top: 0,
          child: IconButton(
            splashRadius: 25,
            onPressed: () {},
            icon: const Icon(Icons.edit),
            color: Palette.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _renderHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.defaultPadding,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hồ sơ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            "Học hỏi, khám phá và chia sẻ!",
            style: TextStyle(color: Palette.darkGrey),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
