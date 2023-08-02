import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';

class NotificationButton extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  const NotificationButton({super.key, required this.onTap});

  @override
  ConsumerState<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<NotificationButton> {
  @override
  void initState() {
    super.initState();
    ref.read(notificationControllerProvider.notifier).getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          iconSize: 36,
          splashRadius: 30,
          onPressed: widget.onTap,
          icon: SvgPicture.asset(
            IconPaths.notification,
            colorFilter: const ColorFilter.mode(
              Palette.darkGrey,
              BlendMode.srcIn,
            ),
            width: 36,
            height: 36,
          ),
        ),
        ref.watch(notificationControllerProvider).when(
              error: (err, stk) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              data: (notificationList) {
                if (!notificationList.any(
                  (e) => e.status == NotificationStatus.pending.name,
                )) return const SizedBox.shrink();

                return Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bannerColors['red'],
                      border: Border.all(color: Palette.lightGrey),
                    ),
                  ),
                );
              },
            )
      ],
    );
  }
}
