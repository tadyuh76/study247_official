import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/core/shared/widgets/user_mastery_progress_bar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/profile/controller/profile_controller.dart';
import 'package:study247/features/profile/screens/profile_screen.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';

class UserInfoDialog extends StatelessWidget {
  final UserModel user;
  final bool joinable;
  const UserInfoDialog({
    super.key,
    required this.user,
    this.joinable = false,
  });

  bool get _isStudyingGroup => user.status == UserStatus.studyingGroup.name;

  void _showUserProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Palette.lightGrey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Palette.lightGrey,
            automaticallyImplyLeading: true,
          ),
          body: ProfileScreen(user: user),
        ),
      ),
    );
  }

  void _studyWithFriend(BuildContext context) {
    context
        .go("/room/${user.studyingRoomId}?meetingId=${user.studyingMeetingId}");
  }

  @override
  Widget build(BuildContext context) {
    final userMasteryLevel = user.getMasteryLevel();

    return FeatureDialog(
      title: "Hồ sơ",
      iconPath: IconPaths.profile,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showUserProfile(context),
            child: MasteryAvatar(
              radius: 50,
              photoURL: user.photoURL,
              masteryLevel: userMasteryLevel,
              status: user.status,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "- ${masteryTitles[userMasteryLevel]} -",
            style: const TextStyle(color: Palette.darkGrey),
          ),
          const SizedBox(height: 10),
          Text(
            userStatusTitles[user.status]!,
            style: TextStyle(
              color: userStatusColors[user.status],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_isStudyingGroup && joinable) const SizedBox(height: 10),
          if (_isStudyingGroup && joinable)
            CustomButton(
              text: "Học cùng ${user.displayName}",
              onTap: () => _studyWithFriend(context),
              primary: true,
            ),
          const SizedBox(height: 10),
          Consumer(
            builder: (context, ref, child) {
              final userId =
                  ref.read(authControllerProvider).asData!.value!.uid;
              final isSameUser = userId == user.uid;

              return isSameUser
                  ? UserMasteryProgressBar(
                      totalStudyTime: user.totalStudyTime,
                      masteryLevel: userMasteryLevel,
                    )
                  : _AddFriendButton(participantId: user.uid);
            },
          ),
        ],
      ),
    );
  }
}

class _AddFriendButton extends ConsumerStatefulWidget {
  final String participantId;
  const _AddFriendButton({required this.participantId});

  @override
  ConsumerState<_AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends ConsumerState<_AddFriendButton> {
  bool _added = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authControllerProvider).asData!.value!;
    final participantId = widget.participantId;
    final isFriend = user.isFriendWith(participantId);

    setState(() => _added = isFriend);
  }

  Future<void> _addFriend() async {
    ref.read(profileControllerProvider).addFriend(widget.participantId);
    setState(() => _added = true);
  }

  Future<void> _unFriend() async {
    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        title: "Huỷ kết bạn",
        child: const Text(
          "Bạn có chắc chắn muốn huỷ kết bạn với người này?",
        ),
        onAccept: () {
          ref.read(profileControllerProvider).unFriend(widget.participantId);
          setState(() => _added = false);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Material(
        color: _added ? Palette.white : Palette.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: _added ? _unFriend : _addFriend,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border:
                  _added ? Border.all(color: Palette.primary, width: 2) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      _added ? IconPaths.deletePeople : IconPaths.addPeople,
                      colorFilter: ColorFilter.mode(
                        _added ? Palette.primary : Palette.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _added ? 'Huỷ kết bạn' : 'Thêm bạn',
                      style: TextStyle(
                        color: _added ? Palette.primary : Palette.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
