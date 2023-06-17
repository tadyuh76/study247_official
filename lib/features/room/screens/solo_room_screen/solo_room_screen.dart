import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/core/shared/widgets/custom_icon_button.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:study247/features/file/widgets/file_view.dart';
import 'package:study247/features/music/controllers/music_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dots_menu.dart';
import 'package:study247/features/room/screens/solo_room_screen/widgets/solo_timer_tab.dart';
import 'package:study247/features/room_background/controllers/room_background_controller.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';
import 'package:study247/features/session_goals/widgets/session_goals_tab.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final GlobalKey globalKey = GlobalKey(debugLabel: "solo - displaying dialogs");

class SoloRoomScreen extends ConsumerStatefulWidget {
  SoloRoomScreen() : super(key: globalKey);

  @override
  ConsumerState<SoloRoomScreen> createState() => _SoloRoomScreenState();
}

class _SoloRoomScreenState extends ConsumerState<SoloRoomScreen> {
  final PageController _pageController = PageController();
  bool _isSecondPage = false;

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
          if (ref.exists(fileControllerProvider)) {
            ref.read(fileControllerProvider.notifier).reset();
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
          if (ref.exists(personalTimerProvider)) {
            ref.read(personalTimerProvider.notifier).reset();
            // ref.invalidate(personalTimerProvider);
          }
          if (ref.exists(roomBackgroundControllerProvider)) {
            ref.read(roomBackgroundControllerProvider).urlController.clear();
            ref.read(roomBackgroundControllerProvider).selectingVideoIdx = -1;
            ref.read(roomBackgroundControllerProvider).videoController.reset();
          }
          context
            ..pop()
            ..pop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExitRoom,
      child: LayoutBuilder(builder: (context, constraints) {
        final landscape = constraints.maxWidth > constraints.maxHeight;

        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton:
              _renderFloatingActionButtons(landscape, context),
          extendBodyBehindAppBar: true,
          appBar: landscape ? null : _renderAppBar(),
          body: Stack(
            children: [
              _renderBackground(),
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constants.defaultPadding / 2)
                        .copyWith(top: landscape ? 10 : 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SoloTimerTab(),
                        const SizedBox(width: 10),
                        const SessionGoalsTab(),
                        if (!landscape) const Spacer(),
                        if (!landscape) const DotsMenu()
                      ],
                    ),
                  ),
                  FileView(solo: true, landscape: landscape),
                ],
              ),
              _renderNavigators(),
            ],
          ),
        );
      }),
    );
  }

  SizedBox _renderBackground() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: YoutubePlayer(
          controller: ref.watch(
            roomBackgroundControllerProvider
                .select((value) => value.videoController),
          ),
        ),
      ),
    );
  }

  Padding _renderFloatingActionButtons(bool landscape, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding / 2,
        vertical: Constants.defaultPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BlackBackgroundButton(
            width: 60,
            onTap: landscape ? _onPortrait : _onFullScreen,
            child: Icon(
              landscape
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              color: Palette.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Align _renderNavigators() {
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

  AppBar _renderAppBar() {
    return AppBar(
      backgroundColor: Palette.black.withOpacity(0.5),
      foregroundColor: Palette.white,
      titleSpacing: Constants.defaultPadding,
      elevation: 0,
      title: const Text(
        "Phòng học cá nhân",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
