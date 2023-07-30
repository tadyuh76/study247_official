import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/responsive/responsive.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/web_app_bar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/badge/controller/badge_list_controller.dart';
import 'package:study247/features/profile/widgets/monthly_statistics.dart';
import 'package:study247/features/profile/widgets/user_badges.dart';
import 'package:study247/features/profile/widgets/user_info.dart';
import 'package:study247/features/profile/widgets/user_streak.dart';
import 'package:study247/features/profile/widgets/weekly_statistics.dart';

class ProfileScreen extends ConsumerWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  Future<void> _onRefresh(WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).updateUser();
    ref.read(badgeListControllerProvider.notifier).getBadgeList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      desktopLayout: _renderDesktopLayout(context, ref, user),
      mobileLayout: RefreshIndicator(
        onRefresh: () => _onRefresh(ref),
        child: SingleChildScrollView(
          child: user != null
              ? _renderProfileScreen(context, user!)
              : ref.watch(authControllerProvider).when(
                    error: (err, stk) => const AppError(),
                    loading: () => const AppLoading(),
                    data: (user) {
                      if (user == null) {
                        return const Text("Đã có lỗi xảy ra...");
                      }

                      return _renderProfileScreen(
                        context,
                        user,
                        editable: true,
                      );
                    },
                  ),
        ),
      ),
    );
  }

  Widget _renderDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    UserModel? user,
  ) {
    user ??= ref.watch(authControllerProvider).asData!.value!;

    return Scaffold(
      backgroundColor: Palette.lightGrey,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          WebAppBar(user: user, back: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserInfo(user: user, editable: false, contain: true),
                          const SizedBox(height: 20),
                          UserBadges(user: user, editable: false),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          WeeklyStatistics(user: user),
                          const SizedBox(height: 20),
                          UserStreak(user: user)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MonthlyStatistics(user: user),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderProfileScreen(
    BuildContext context,
    UserModel user, {
    bool editable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _renderHeader(),
        const SizedBox(height: 30),
        UserInfo(user: user, editable: editable),
        const SizedBox(height: Constants.defaultPadding),
        UserBadges(user: user, editable: editable),
        const SizedBox(height: Constants.defaultPadding),
        UserStreak(user: user),
        const SizedBox(height: Constants.defaultPadding),
        WeeklyStatistics(user: user),
        const SizedBox(height: Constants.defaultPadding),
        MonthlyStatistics(user: user),
        const SizedBox(height: Constants.defaultPadding),
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
