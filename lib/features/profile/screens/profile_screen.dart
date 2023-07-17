import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Hồ sơ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Palette.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
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
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(color: Palette.grey, width: 10),
                        ),
                        child: Avatar(photoURL: user.photoURL, radius: 50),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.edit, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Center(
                      child: Text(
                        "- Người mới -",
                        style: TextStyle(
                          fontSize: 12,
                          color: Palette.darkGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: Constants.defaultPadding),
                    const Divider(
                        height: 20, color: Palette.grey, thickness: 1),
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
        }),
      ),
    );
  }
}
