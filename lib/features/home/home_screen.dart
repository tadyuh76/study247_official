import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/document/screens/document_screen.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/features/home/widgets/custom_drawer.dart';
import 'package:study247/features/home/widgets/room_card/room_card.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';
import 'package:study247/utils/unfocus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _menuController;
  double x = 0, y = 0;
  bool _menuOpened = false;
  int _currentIndex = 0;

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

    if (_menuOpened) {
      _menuController.reverse();
      x = 0;
      y = 0;
    } else {
      _menuController.forward();
      x = size.width * 0.7;
      y = size.height * 0.15;
    }
    _menuOpened = !_menuOpened;
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
            borderRadius: _menuOpened
                ? BorderRadius.circular(Constants.defaultPadding)
                : null,
            boxShadow: _menuOpened
                ? [
                    BoxShadow(
                      blurRadius: 32,
                      color: Palette.darkGrey.withOpacity(0.5),
                    )
                  ]
                : null,
          ),
          transform: Matrix4.translationValues(x, y, 0)
            ..scale(_menuOpened ? 0.8 : 1.00),
          child: Unfocus(
            child: Scaffold(
              bottomNavigationBar: _renderNavBar(),
              appBar: _currentIndex == 0 ? _renderAppBar() : null,
              body: RefreshIndicator(
                onRefresh: () => ref
                    .read(roomListControllerProvider.notifier)
                    .getRoomList(refresh: true),
                child: _currentIndex == 0
                    ? _renderHomeScreenContent()
                    : const DocumentScreen(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _renderHomeScreenContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const CreateCard(), _renderRoomList()],
      ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
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
    );
  }

  SizedBox _renderNavBar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _currentIndex = 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconPaths.home,
                      color: _currentIndex == 0
                          ? Palette.primary
                          : Palette.darkGrey,
                      width: 32,
                    ),
                    Text(
                      'Trang chủ',
                      style: TextStyle(
                        color: _currentIndex == 0
                            ? Palette.primary
                            : Palette.darkGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _currentIndex = 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconPaths.flashcards,
                      color: _currentIndex == 1
                          ? Palette.primary
                          : Palette.darkGrey,
                      width: 32,
                    ),
                    Text(
                      'Tài liệu',
                      style: TextStyle(
                        color: _currentIndex == 1
                            ? Palette.primary
                            : Palette.darkGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
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
