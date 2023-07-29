import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  void _signOut(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                renderUserInfo(ref),
                const SizedBox(height: Constants.defaultPadding),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.55),
                  child: Column(
                    children: [
                      TabItem(
                        text: 'Trang chủ',
                        iconPath: IconPaths.home,
                        focus: true,
                        onTap: () {},
                      ),
                      TabItem(
                        text: 'Cài đặt',
                        iconPath: IconPaths.settings,
                        onTap: () {},
                      ),
                      TabItem(
                        text: 'Về ứng dụng',
                        iconPath: IconPaths.info,
                        onTap: () {},
                      ),
                      TabItem(
                        text: 'Đăng xuất',
                        iconPath: IconPaths.logOut,
                        onTap: () => _signOut(context, ref),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget renderUserInfo(WidgetRef ref) {
    return ref.watch(authControllerProvider).when(
          data: (user) => Row(
            children: [
              Avatar(photoURL: user!.photoURL, radius: 24),
              const SizedBox(width: Constants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.black,
                        fontSize: 14,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: Palette.darkGrey,
                        fontSize: 14,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          error: (err, stk) => const AppError(),
          loading: () => const AppLoading(),
        );
  }
}

class TabItem extends StatelessWidget {
  final bool focus;
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  const TabItem({
    super.key,
    this.focus = false,
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.defaultPadding / 2),
      child: Material(
        color: focus ? Palette.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding / 2),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    focus ? Palette.white : Palette.darkGrey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: Constants.defaultPadding),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: focus ? Palette.white : Palette.darkGrey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
