import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MasteryAvatar(
                        radius: 30,
                        photoURL: user.photoURL,
                        masteryLevel: user.masteryLevel,
                      ),
                      const SizedBox(width: Constants.defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
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
                              "Người mới",
                              style: TextStyle(
                                fontSize: 12,
                                color: Palette.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding),
                const Divider(height: 20, color: Palette.grey, thickness: 1),
                const Text(
                  "Thống kê",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text("badges"),
                const Text("study streak"),
                const Text("commit board"),
              ],
            );
          });
    });
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
