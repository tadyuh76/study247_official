import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/features/friends/controller/friend_list_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/participant_info_dialog.dart';

class FriendList extends ConsumerWidget {
  const FriendList({super.key});

  void _showUserProfile(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => ParticipantInfoDialog(user: user, joinable: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(friendListControllerProvider).when(
          error: (err, stk) => const AppError(),
          loading: () => const AppLoading(),
          data: (friendList) {
            if (friendList.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(left: Constants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bạn bè",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      itemCount: friendList.length  ,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = friendList[index];

                        return _renderUser(context, user);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }

  SizedBox _renderUser(BuildContext context, UserModel user) {
    return SizedBox(
      width: 80,
      child: GestureDetector(
        onTap: () => _showUserProfile(context, user),
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              MasteryAvatar(
                radius: 25,
                photoURL: user.photoURL,
                masteryLevel: user.masteryLevel,
                status: user.status,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  width: 65,
                  child: Text(
                    user.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
