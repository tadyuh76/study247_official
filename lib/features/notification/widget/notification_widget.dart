import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/badge.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/utils/format_date.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({super.key, required this.notification});

  void _onFriendRequestAccept() {}

  void _onFriendRequestReject() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Builder(builder: (context) {
          if (notification.type == NotificationType.newBadge.name) {
            return _renderNewBadgeNotification();
          } else if (notification.type == NotificationType.levelUp.name) {
            return _renderLevelUpNotification();
          } else if (notification.type == NotificationType.friendRequest.name) {
            return _renderFriendRequestNotification();
          } else {
            return _renderFriendAcceptNotification();
          }
        }));
  }

  Widget _renderNewBadgeNotification() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Palette.lightGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              badgeAssetPaths[notification.payload]!,
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                notification.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                formatDate(DateTime.parse(notification.timestamp).toString()),
                style: const TextStyle(fontSize: 12, color: Palette.darkGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderLevelUpNotification() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Palette.lightGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              masteryIconPaths[int.parse(notification.payload)],
              width: 50,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                notification.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                formatDate(DateTime.parse(notification.timestamp).toString()),
                style: const TextStyle(fontSize: 12, color: Palette.darkGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderFriendRequestNotification() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundColor: Palette.lightGrey,
            backgroundImage: NetworkImage(notification.photoURL),
            radius: 30,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                notification.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                formatDate(DateTime.parse(notification.timestamp).toString()),
                style: const TextStyle(fontSize: 12, color: Palette.darkGrey),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "Chấp nhận",
                    onTap: _onFriendRequestAccept,
                    primary: true,
                  ),
                  CustomButton(
                    text: "Xoá",
                    onTap: _onFriendRequestReject,
                    // primary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderFriendAcceptNotification() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Palette.lightGrey,
          backgroundImage: NetworkImage(notification.photoURL),
          radius: 30,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                notification.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                formatDate(DateTime.parse(notification.timestamp).toString()),
                style: const TextStyle(fontSize: 12, color: Palette.darkGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
