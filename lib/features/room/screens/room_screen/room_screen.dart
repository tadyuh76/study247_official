import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/custom_icon_button.dart';
import 'package:study247/features/chat/controllers/chat_controller.dart';
import 'package:study247/features/chat/controllers/chat_list_controller.dart';
import 'package:study247/features/chat/widgets/chat_view.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:study247/features/file/widgets/file_view.dart';
import 'package:study247/features/music/controllers/music_controller.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dots_menu.dart';
import 'package:study247/features/room/screens/room_screen/widgets/room_features/invite_button.dart';
import 'package:study247/features/session_goals/controllers/session_goals_controller.dart';
import 'package:study247/features/timer/notifiers/personal_timer.dart';
import 'package:study247/features/timer/notifiers/room_timer.dart';
import 'package:study247/features/timer/providers/timer_type.dart';
import 'package:study247/features/timer/widgets/timer_tab.dart';
import 'package:study247/features/session_goals/widgets/session_goals_tab.dart';

final GlobalKey globalKey = GlobalKey(debugLabel: "displaying dialogs");

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  RoomScreen({required this.roomId}) : super(key: globalKey);

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  final PageController _pageController = PageController();
  bool _isSecondPage = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    await ref
        .read(roomControllerProvider.notifier)
        .getRoomById(context, widget.roomId);
    ref.read(roomTimerProvider.notifier).setup();
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
    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        title: "Thoát phòng học",
        child: const Text("Bạn có chắc chắn muốn rời khỏi phòng học?"),
        onAccept: () {
          if (ref.exists(timerTypeProvider)) {
            ref.invalidate(timerTypeProvider);
          }
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
          if (ref.exists(roomTimerProvider)) {
            ref.read(roomTimerProvider.notifier).reset();
            // ref.invalidate(roomTimerProvider);
          }
          if (ref.exists(personalTimerProvider)) {
            ref.read(personalTimerProvider.notifier).reset();
            // ref.invalidate(personalTimerProvider);
          }
          if (ref.exists(chatListController)) {
            ref.invalidate(chatListController);
          }
          if (ref.exists(selectingMessageProvider)) {
            ref.invalidate(selectingMessageProvider);
          }
          ref.read(roomControllerProvider.notifier).reset();
          context
            ..pop()
            ..pop();
        },
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(roomControllerProvider).when(
          error: (error, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (room) => WillPopScope(
            onWillPop: _onExitRoom,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: _renderAppBar(),
              body: SafeArea(
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1535982330050-f1c2fb79ff78?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80",
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                    Constants.defaultPadding / 2)
                                .copyWith(top: Constants.defaultPadding),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    RoomTimerTab(),
                                    SizedBox(
                                      width: Constants.defaultPadding / 2,
                                    ),
                                    SessionGoalsTab(),
                                    Spacer(),
                                    DotsMenu()
                                  ],
                                ),
                                Spacer(),
                                ChatButton()
                              ],
                            ),
                          ),
                        ),
                        const FileView()
                      ],
                    ),
                    _renderNavigators()
                  ],
                ),
              ),
            ),
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
      backgroundColor: Palette.white,
      titleSpacing: Constants.defaultPadding,
      elevation: 3,
      title: Row(
        children: [
          Text(ref.read(roomControllerProvider).asData!.value!.name),
          const Spacer(),
          const InviteButton(),
        ],
      ),
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => const ChatView(),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Palette.primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SvgPicture.asset(
            IconPaths.chats,
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
