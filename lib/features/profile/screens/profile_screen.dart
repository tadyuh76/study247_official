import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/profile/widgets/monthly_statistics.dart';
import 'package:study247/features/profile/widgets/user_info.dart';
import 'package:study247/features/profile/widgets/user_streak.dart';
import 'package:study247/features/profile/widgets/weekly_statistics.dart';

class ProfileScreen extends ConsumerWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: user == null
          ? () => ref.read(authControllerProvider.notifier).updateUser()
          : () async {},
      child: SingleChildScrollView(
        child: user != null
            ? _renderProfileScreen(user!)
            : ref.watch(authControllerProvider).when(
                  error: (err, stk) => const AppError(),
                  loading: () => const AppLoading(),
                  data: (user) {
                    if (user == null) return const Text("Đã có lỗi xảy ra...");

                    return _renderProfileScreen(user, editable: true);
                  },
                ),
      ),
    );
  }

  Widget _renderProfileScreen(UserModel user, {bool editable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _renderHeader(),
        const SizedBox(height: 30),
        UserInfo(user: user, editable: editable),
        const SizedBox(height: Constants.defaultPadding),
        // UserBadges(user: user),
        // const SizedBox(height: Constants.defaultPadding),
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
