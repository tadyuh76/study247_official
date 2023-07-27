import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/badge.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/profile/controller/profile_controller.dart';
import 'package:study247/utils/format_date.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({super.key, required this.notification});

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
              _FriendRequestActions(
                friendId: notification.payload,
                notificationStatus: notification.status,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FriendRequestActions extends ConsumerStatefulWidget {
  final String friendId;
  final String notificationStatus;
  const _FriendRequestActions(
      {required this.friendId, required this.notificationStatus});

  @override
  ConsumerState<_FriendRequestActions> createState() =>
      _FriendRequestActionsState();
}

class _FriendRequestActionsState extends ConsumerState<_FriendRequestActions> {
  bool responded = false;
  bool accepted = false;

  @override
  void initState() {
    super.initState();
    if (widget.notificationStatus == NotificationStatus.accepted.name) {
      responded = true;
      accepted = true;
    } else if (widget.notificationStatus == NotificationStatus.rejected.name) {
      responded = true;
      accepted = false;
    }
  }

  void _onFriendRequestAccept() {
    ref.read(profileControllerProvider).acceptFriend(widget.friendId);
    setState(() {
      responded = true;
      accepted = true;
    });
  }

  void _onFriendRequestReject() {
    ref.read(profileControllerProvider).rejectFriend(widget.friendId);
    setState(() {
      responded = true;
      accepted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return responded
          ? accepted
              ? const Text("Đã đồng ý.")
              : const Text("Đã xoá.")
          : Row(
              children: [
                GestureDetector(
                  onTap: _onFriendRequestAccept,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Palette.primary, width: 2),
                      color: Palette.primary,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Chấp nhận",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _onFriendRequestReject,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Palette.primary, width: 2),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Xoá",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Palette.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }
}
