import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dots_menu.dart';
import 'package:study247/features/room/screens/room_screen/widgets/room_features/invite_button.dart';
import 'package:study247/features/room_timer/widgets/room_timer_tab.dart';
import 'package:study247/features/session_goals/widgets/session_goals_tab.dart';

final GlobalKey globalKey = GlobalKey(debugLabel: "displaying dialogs");

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  RoomScreen({required this.roomId}) : super(key: globalKey);

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  @override
  void initState() {
    super.initState();
    getRoomById();
  }

  Future<void> getRoomById() async {
    await ref
        .read(roomControllerProvider.notifier)
        .getRoomById(context, widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(roomControllerProvider).when(
          error: (error, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (room) => Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _renderAppBar(),
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://i.pinimg.com/originals/0d/09/97/0d09978f0fb05b5cce9a2c863cae56cc.jpg",
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding / 2)
                      .copyWith(top: Constants.defaultPadding),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          RoomTimerTab(),
                          SizedBox(width: Constants.defaultPadding / 2),
                          SessionGoalsTab(),
                          Spacer(),
                          DotsMenu()
                        ],
                      ),
                      const Spacer(),
                      Align(
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
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
