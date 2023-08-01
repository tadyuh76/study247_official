import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/responsive/responsive.dart';
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
    if (user.uid.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Palette.lightGrey,
          appBar: Responsive.isDesktop(context)
              ? null
              : AppBar(
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

  Future<void> _onReport(BuildContext context, [bool mounted = true]) async {
    final url = Uri.parse(
      "https://docs.google.com/forms/d/e/1FAIpQLSeKvCSySL3C2qjYbYJstYpoM_9IRgjErWlhecvXAxg8Y6-elQ/viewform?usp=sf_link",
    );
    if (!await launchUrl(url)) {
      if (mounted) showSnackBar(context, "Không thể mở đường dẫn!");
    }
  }

  Future<void> _copyUserId(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: "${user.displayName}\n${user.uid}"),
    );
    if (context.mounted) {
      showSnackBar(context, "Đã sao chép Tên và ID của người dùng này.");
    }
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => _copyUserId(context),
                child: const Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: Palette.primary,
                ),
              ),
            ],
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
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final userId =
                        ref.read(authControllerProvider).asData!.value!.uid;
                    final isSameUser = userId == user.uid;

                    if (userId.isEmpty) return const SizedBox.shrink();

                    return isSameUser
                        ? UserMasteryProgressBar(
                            monthStudyTime: user.getMonthStudyTime(),
                            masteryLevel: userMasteryLevel,
                          )
                        : Row(
                            children: [
                              Expanded(
                                  child: _AddFriendButton(
                                      participantId: user.uid)),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => _onReport(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Palette.darkGrey, width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: const Icon(
                                    Icons.report,
                                    size: 32,
                                    color: Palette.darkGrey,
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ],
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
  bool _requested = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authControllerProvider).asData!.value!;
    final participantId = widget.participantId;

    _added = user.isFriendWith(participantId);
    _requested = user.isFriendRequestPending(participantId);
    setState(() {});
  }

  Future<void> _requestFriend() async {
    ref.read(profileControllerProvider).requestFriend(widget.participantId);
    setState(() => _requested = true);
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

  Future<void> _unRequest() async {
    ref.read(profileControllerProvider).unRequest(widget.participantId);
    setState(() => _requested = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Material(
        color: _added || _requested ? Palette.white : Palette.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: _added
              ? _unFriend
              : _requested
                  ? _unRequest
                  : _requestFriend,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: _added || _requested
                  ? Border.all(color: Palette.primary, width: 2)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      _added || _requested
                          ? IconPaths.deletePeople
                          : IconPaths.addPeople,
                      colorFilter: ColorFilter.mode(
                        _added || _requested ? Palette.primary : Palette.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _added
                          ? 'Huỷ kết bạn'
                          : _requested
                              ? 'Huỷ lời mời'
                              : 'Thêm bạn',
                      style: TextStyle(
                        color: _added || _requested
                            ? Palette.primary
                            : Palette.white,
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
