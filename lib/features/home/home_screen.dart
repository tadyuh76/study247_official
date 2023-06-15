import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/features/home/widgets/custom_drawer.dart';
import 'package:study247/features/home/widgets/room_card/room_card.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _menuController;
  double x = 0, y = 0;
  bool menuOpened = false;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _menuController.dispose();
  }

  void _onMenuTap() {
    final size = MediaQuery.of(context).size;

    if (menuOpened) {
      _menuController.reverse();
      x = 0;
      y = 0;
    } else {
      _menuController.forward();
      x = size.width * 0.7;
      y = size.height * 0.15;
    }
    menuOpened = !menuOpened;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomDrawer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: menuOpened
                ? BorderRadius.circular(Constants.defaultPadding)
                : null,
            boxShadow: menuOpened
                ? [
                    BoxShadow(
                      blurRadius: 32,
                      color: Palette.darkGrey.withOpacity(0.5),
                    )
                  ]
                : null,
          ),
          transform: Matrix4.translationValues(x, y, 0)
            ..scale(menuOpened ? 0.8 : 1.00),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Palette.white,
              title: const Text(
                Constants.appName,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              titleSpacing: 0,
              elevation: 0,
              leading: IconButton(
                splashRadius: 25,
                onPressed: _onMenuTap,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _menuController,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => ref
                  .read(roomListControllerProvider.notifier)
                  .getRoomList(refresh: true),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const CreateCard(), _renderRoomList()],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderRoomList() {
    return ref.watch(roomListControllerProvider).when(
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
          error: (e, stk) => const AppError(),
          loading: () => const AppLoading(),
        );
  }
}
