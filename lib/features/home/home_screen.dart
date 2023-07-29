import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/friends/controller/friend_list_controller.dart';
import 'package:study247/features/friends/widgets/friend_list_widget.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/features/home/widgets/room_card/room_card.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';
import 'package:study247/features/notification/widget/notification_button.dart';
import 'package:study247/features/notification/widget/notification_dialog.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    await ref
        .read(roomListControllerProvider.notifier)
        .getRoomList(refresh: true);
    await ref
        .read(friendListControllerProvider.notifier)
        .getFriendList(refresh: true);
    await ref.read(authControllerProvider.notifier).updateUser();
  }

  void _onNotificationTap(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const NotificationDialog(),
    );
    ref.read(notificationControllerProvider.notifier).readAllNotifications();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderHeader(context, ref),
            const CreateCard(),
            const FriendList(),
            const SizedBox(height: Constants.defaultPadding),
            const Padding(
              padding: EdgeInsets.only(left: Constants.defaultPadding),
              child: Text(
                "Danh sách phòng học",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            _renderRoomList(ref),
          ],
        ),
      ),
    );
  }

  Widget _renderHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.defaultPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500),
                  ref.watch(authControllerProvider).when(
                        error: (err, stk) => "",
                        loading: () => "",
                        data: (user) =>
                            "Chào ${user!.displayName.split(" ").last},",
                      ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Bắt đầu một phiên học mới nào!",
                  style: TextStyle(color: Palette.darkGrey),
                ),
                // SizedBsox(height: 10),
              ],
            ),
          ),
          NotificationButton(onTap: () => _onNotificationTap(context, ref)),
        ],
      ),
    );
  }

  Widget _renderRoomList(WidgetRef ref) {
    return ref.watch(roomListControllerProvider).when(
          error: (e, stk) => const AppError(),
          loading: () => const AppLoading(),
          data: (roomList) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => RoomCard(
                room: roomList[index],
                key: Key(roomList[index].id!),
              ),
              itemCount: roomList.length,
            );
          },
        );
  }
}
