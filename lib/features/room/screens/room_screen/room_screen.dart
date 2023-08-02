import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/core/shared/widgets/custom_icon_button.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/chat/controllers/chat_controller.dart';
import 'package:study247/features/chat/controllers/chat_list_controller.dart';
import 'package:study247/features/chat/widgets/chat_view.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:study247/features/file/widgets/file_view.dart';
import 'package:study247/features/music/controllers/music_controller.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';
import 'package:study247/features/profile/controller/profile_controller.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dots_menu.dart';
import 'package:study247/features/room/screens/room_screen/widgets/participant_tile.dart';
import 'package:study247/features/room/screens/room_screen/widgets/room_features/invite_button.dart';
import 'package:study247/features/room_background/controllers/room_background_controller.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';
import 'package:study247/features/session_goals/widgets/session_goals_tab.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:study247/features/timer/notifiers/room_timer.dart';
import 'package:study247/features/timer/providers/timer_type.dart';
import 'package:study247/features/timer/widgets/timer_tab.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videosdk/videosdk.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final GlobalKey globalKey =
    GlobalKey(debugLabel: "displaying dialogs within room screen");

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String meetingId;
  RoomScreen({
    required this.roomId,
    required this.meetingId,
  }) : super(key: globalKey);

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  final PageController _pageController = PageController();
  bool _isSecondPage = false;
  bool _showParticipants = true;
  bool camEnabled = false;
  bool micEnabled = false;

  bool allowMic = false;
  bool allowCamera = true;

  late Room _room;
  Map<String, (Participant, UserModel)> participants = {};

  late Timer _studyTimeTracker;

  void _checkForNonUser() {
    final user = ref.read(authControllerProvider).asData?.value;
    if (user == null) {
      ref.read(authControllerProvider.notifier).signInAnonymously(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkForNonUser();

    _studyTimeTracker = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.read(profileControllerProvider).updateStudyTime();
    });

    _setup();
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: Constants.videoSDKToken,
      displayName: ref.read(authControllerProvider).asData!.value!.displayName,
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: 1,
    );

    _setMeetingEventListener();
    _room.join();
  }

  @override
  void dispose() {
    _studyTimeTracker.cancel();
    super.dispose();
  }

  void _setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      final user = ref.read(authControllerProvider).asData!.value!;
      setState(() {
        participants.putIfAbsent(
          _room.localParticipant.id,
          () => (_room.localParticipant, user),
        );
      });
    });

    _room.on(Events.participantJoined, (Participant participant) async {
      final user = await ref
          .read(roomControllerProvider.notifier)
          .getRoomUserByName(widget.roomId, participant.displayName);

      setState(
        () => participants.putIfAbsent(
          participant.id,
          () => (participant, user!),
        ),
      );
    });

    _room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() => participants.remove(participantId));
      }
    });

    _room.on(Events.roomLeft, () {
      participants.clear();
      // Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  Future<void> _setup() async {
    final roomController = ref.read(roomControllerProvider.notifier);

    await roomController.getRoomById(context, widget.roomId);
    await roomController.joinRoom(widget.roomId, widget.meetingId);
    ref.read(roomTimerProvider.notifier).setup();

    final room = ref.read(roomControllerProvider).asData!.value!;
    allowCamera = room.allowCamera;
    allowMic = room.allowMic;
    ref
        .read(roomBackgroundControllerProvider)
        .selectColorBackground(room.bannerColor);
    setState(() {});
  }

  void _onLeftNavigatorTap() {
    _pageController
        .animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        )
        .then(
          (_) => setState(() => _isSecondPage = false),
        );
  }

  void _onRightNavigatorTap() {
    _pageController
        .animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        )
        .then(
          (_) => setState(() => _isSecondPage = true),
        );
  }

  Future<bool> _onExitRoom() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        title: "Thoát phòng học",
        child: const Text("Bạn có chắc chắn muốn rời khỏi phòng học?"),
        onAccept: () {
          ref.read(roomListControllerProvider.notifier).getRoomList();

          if (ref.exists(timerTypeProvider)) {
            ref.invalidate(timerTypeProvider);
          }
          if (ref.exists(fileControllerProvider)) {
            ref.read(fileControllerProvider.notifier).removeFile();
            ref.invalidate(fileControllerProvider);
          }
          if (ref.exists(sessionGoalsControllerProvider)) {
            ref.read(sessionGoalsControllerProvider.notifier).reset();
            ref.invalidate(sessionGoalsControllerProvider);
          }
          if (ref.exists(audioControllerProvider)) {
            ref.read(audioControllerProvider.notifier).reset();
            ref.invalidate(audioControllerProvider);
          }
          if (ref.exists(roomTimerProvider)) {
            ref.read(roomTimerProvider.notifier).reset();
          }
          if (ref.exists(personalTimerProvider)) {
            ref.read(personalTimerProvider.notifier).reset();
          }
          if (ref.exists(chatListController)) {
            ref.invalidate(chatListController);
          }
          if (ref.exists(selectingMessageProvider)) {
            ref.invalidate(selectingMessageProvider);
          }
          if (ref.exists(roomBackgroundControllerProvider)) {
            ref.read(roomBackgroundControllerProvider).urlController.clear();
            ref.read(roomBackgroundControllerProvider).selectingVideoIdx = -1;
            ref.read(roomBackgroundControllerProvider).videoController.reset();
          }
          // if (ref.exists(file))
          if (ref.exists(roomControllerProvider)) {
            ref.read(roomControllerProvider.notifier)
              ..leaveRoom()
              ..reset();
          }

          // if (ref.exists(notificationcon))
          ref.read(notificationControllerProvider.notifier).getNotifications();
          ref.read(profileControllerProvider).updateUserStatus(
                status: UserStatus.active,
                studyingRoomId: "",
                studyingMeetingId: "",
              );

          context.go('/');
          _room.leave();
        },
      ),
    );

    return false;
  }

  void _onFullScreen() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _onPortrait() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _launchGooglePlay() async {
    final url = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.tadyuh.study247",
    );
    if (!await launchUrl(url)) {
      if (mounted) showSnackBar(context, "Không thể mở đường dẫn!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExitRoom,
      child: ref.watch(roomControllerProvider).when(
            error: (error, stk) => const ErrorScreen(),
            loading: () => const LoadingScreen(),
            data: (room) => LayoutBuilder(builder: (context, constraints) {
              final landscape = constraints.maxWidth > constraints.maxHeight;

              return Scaffold(
                backgroundColor: Colors.grey.shade900,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton:
                    _renderFloatingActionButtons(landscape, context),
                extendBodyBehindAppBar: true,
                appBar: landscape && !kIsWeb ? null : _renderAppBar(),
                body: Stack(
                  children: [
                    _renderBackground(),
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _renderMainView(landscape),
                        if (!kIsWeb) FileView(landscape: landscape),
                      ],
                    ),
                    if (!kIsWeb) _renderNavigators(),
                  ],
                ),
              );
            }),
          ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      backgroundColor: Palette.black.withOpacity(0.5),
      foregroundColor: Palette.white,
      titleSpacing: 0,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Text(
              ref.read(roomControllerProvider).asData!.value!.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (kIsWeb) _renderWebCTA(),
          if (kIsWeb) const SizedBox(width: Constants.defaultPadding),
          if (!kIsWeb) const InviteButton(),
          const SizedBox(width: Constants.defaultPadding),
        ],
      ),
    );
  }

  Widget _renderBackground() {
    final roomBackgroundController =
        ref.watch(roomBackgroundControllerProvider);
    final isColorBackground =
        roomBackgroundController.mode == BackgroundMode.color;

    return Stack(children: [
      Container(
        color: bannerColors[roomBackgroundController.backgroundColor],
      ),
      Opacity(
        opacity: isColorBackground ? 0 : 1,
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: YoutubePlayer(
              controller: ref.watch(
                roomBackgroundControllerProvider
                    .select((value) => value.videoController),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _renderMainView(bool landscape) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding / 2).copyWith(
          top: kIsWeb
              ? 60
              : landscape
                  ? 10
                  : 100),
      child: Stack(
        children: [
          _renderParticipants(landscape),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RoomTimerTab(),
              const SizedBox(width: 10),
              const SessionGoalsTab(),
              if (!landscape || kIsWeb) const Spacer(),
              if (!landscape || kIsWeb) const DotsMenu()
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderParticipants(bool landscape) {
    return Opacity(
      opacity: _showParticipants ? 1 : 0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: 80,
          bottom: landscape ? 20 : 80,
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: kIsWeb && landscape ? 700 : 400),
          child: Center(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kIsWeb && landscape ? 2 : 1,
                  crossAxisSpacing: Constants.defaultPadding,
                  mainAxisSpacing: Constants.defaultPadding,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  return ParticipantTile(
                    key: Key(
                      participants.values.elementAt(index).$1.id,
                    ),
                    participant: participants.values.elementAt(index).$1,
                    user: participants.values.elementAt(index).$2,
                  );
                },
                itemCount: participants.length,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderFloatingActionButtons(bool landscape, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding / 2,
        vertical: Constants.defaultPadding,
      ),
      child: Row(
        mainAxisAlignment:
            landscape ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: kIsWeb
            ? _renderWebActions()
            : landscape
                ? _renderMobileLandscapeActions()
                : _renderMobilePortraitActions(),
      ),
    );
  }

  List<Widget> _renderMobilePortraitActions() {
    return [
      if (allowCamera) _cameraButton(),
      if (allowMic) _micButton(),
      _showParticipantsButton(),
      _chatButton(context),
      _fullScreenButton(false),
    ];
  }

  List<Widget> _renderMobileLandscapeActions() {
    return [
      if (allowCamera) _cameraButton(),
      const SizedBox(width: 10),
      if (allowMic) _micButton(),
      const SizedBox(width: 10),
      _showParticipantsButton(),
      const Spacer(),
      _fullScreenButton(true),
    ];
  }

  List<Widget> _renderWebActions() {
    return [
      if (allowCamera) _cameraButton(),
      const SizedBox(width: 10),
      if (allowMic) _micButton(),
      const SizedBox(width: 10),
      _showParticipantsButton(),
      const Spacer(),
      _chatButton(context),
    ];
  }

  Widget _renderNavigators() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding / 2,
          ),
          child: Align(
            alignment:
                _isSecondPage ? Alignment.centerLeft : Alignment.centerRight,
            child: CustomIconButton(
              backgroundColor: Palette.black.withOpacity(0.7),
              size: 32,
              onTap: _isSecondPage ? _onLeftNavigatorTap : _onRightNavigatorTap,
              child: Icon(
                _isSecondPage ? Icons.arrow_left : Icons.arrow_right,
                size: 32,
                color: Palette.white,
              ),
            ),
          )),
    );
  }

  BlackBackgroundButton _fullScreenButton(bool landscape) {
    return BlackBackgroundButton(
      width: 60,
      onTap: landscape ? _onPortrait : _onFullScreen,
      child: Icon(
        landscape ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
        color: Palette.white,
        size: 32,
      ),
    );
  }

  BlackBackgroundButton _chatButton(BuildContext context) {
    return BlackBackgroundButton(
      width: 60,
      onTap: () => showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => const ChatView(),
      ),
      child: SvgPicture.asset(
        IconPaths.message,
        colorFilter: const ColorFilter.mode(
          Palette.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  BlackBackgroundButton _showParticipantsButton() {
    return BlackBackgroundButton(
      width: 60,
      child: SvgPicture.asset(
        _showParticipants
            ? IconPaths.hideParticipants
            : IconPaths.showParticipants,
        // color: Palette.white,
        colorFilter: const ColorFilter.mode(
          Palette.white,
          BlendMode.srcIn,
        ),
      ),
      onTap: () => setState(() => _showParticipants = !_showParticipants),
    );
  }

  BlackBackgroundButton _micButton() {
    return BlackBackgroundButton(
      width: 60,
      child: SvgPicture.asset(
        micEnabled ? IconPaths.mic : IconPaths.micOff,
        // color: Palette.white,
        colorFilter: const ColorFilter.mode(
          Palette.white,
          BlendMode.srcIn,
        ),
      ),
      onTap: () => setState(() {
        if (micEnabled) {
          _room.muteMic();
        } else {
          _room.unmuteMic();
        }
        micEnabled = !micEnabled;
      }),
    );
  }

  BlackBackgroundButton _cameraButton() {
    return BlackBackgroundButton(
      width: 60,
      child: SvgPicture.asset(
        camEnabled ? IconPaths.camera : IconPaths.cameraOff,
        // color: Palette.white,
        colorFilter: const ColorFilter.mode(
          Palette.white,
          BlendMode.srcIn,
        ),
      ),
      onTap: () => setState(() {
        if (camEnabled) {
          _room.disableCam();
        } else {
          _room.enableCam();
        }
        camEnabled = !camEnabled;
      }),
    );
  }

  Widget _renderWebCTA() {
    return GestureDetector(
      onTap: _launchGooglePlay,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset(IconPaths.googlePlay, width: 24, height: 24),
            const SizedBox(width: 5),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tải ứng dụng trên",
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "Google Play",
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
