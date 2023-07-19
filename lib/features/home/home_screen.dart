import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/search_bar.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/screens/document_screen.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/features/home/widgets/custom_drawer.dart';
import 'package:study247/features/home/widgets/room_card/room_card.dart';
import 'package:study247/features/profile/screens/profile_screen.dart';
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
              backgroundColor: Palette.lightGrey,
              appBar: _renderAppBar(),
              bottomNavigationBar: _renderNavBar(),
              body: RefreshIndicator(
                onRefresh: () => ref
                    .read(roomListControllerProvider.notifier)
                    .getRoomList(refresh: true),
                child: _currentIndex == 0
                    ? _renderHomeScreenContent()
                    : _currentIndex == 1
                        ? const DocumentScreen()
                        : const ProfileScreen(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderHomeScreenContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderHeader(),
          const CreateCard(),
          const AppSearchBar(hintText: "Tìm phòng học..."),
          const SizedBox(height: 10),
          _renderRoomList(),
        ],
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.defaultPadding,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chào Huy,",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            "Bắt đầu một phiên học mới nào!",
            style: TextStyle(color: Palette.darkGrey),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      backgroundColor: Palette.lightGrey,
      centerTitle: true,
      titleSpacing: 0,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: Constants.defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              splashRadius: 25,
              padding: const EdgeInsets.all(0),
              onPressed: _onMenuTap,
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: _menuController,
                size: 30,
              ),
            ),
            ref.watch(authControllerProvider).when(
                  loading: () => const AppLoading(),
                  error: (err, stk) => const SizedBox.shrink(),
                  data: (user) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          IconPaths.streak,
                          width: 20,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          "Chuỗi học: ",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          "2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: Constants.defaultPadding),
                        SvgPicture.asset(
                          IconPaths.clock2,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Mục tiêu: ",
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          "0.3h",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                )
            // const Text(
            //   Constants.appName,
            //   style: TextStyle(fontWeight: FontWeight.w500),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset(
            //     IconPaths.settings,
            //     colorFilter: const ColorFilter.mode(
            //       Palette.black,
            //       BlendMode.srcIn,
            //     ),
            //   ),
            // )
            // Consumer(builder: (context, ref, child) {
            //   return Avatar(photoURL: ref.watch(authControllerProvider).when(data: data, error: error, loading: loading), radius: radius)
            // })
          ],
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
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 0 ? Palette.primary : Palette.darkGrey,
                        BlendMode.srcIn,
                      ),
                      width: 28,
                    ),
                    Text(
                      'Trang chủ',
                      style: TextStyle(
                        color: _currentIndex == 0
                            ? Palette.primary
                            : Palette.darkGrey,
                        fontSize: 10,
                        fontWeight: _currentIndex == 0 ? FontWeight.w500 : null,
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
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 1 ? Palette.primary : Palette.darkGrey,
                        BlendMode.srcIn,
                      ),
                      width: 28,
                    ),
                    Text(
                      'Tài liệu',
                      style: TextStyle(
                        color: _currentIndex == 1
                            ? Palette.primary
                            : Palette.darkGrey,
                        fontSize: 10,
                        fontWeight: _currentIndex == 1 ? FontWeight.w500 : null,
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
                onTap: () => setState(() => _currentIndex = 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconPaths.person,
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 2 ? Palette.primary : Palette.darkGrey,
                        BlendMode.srcIn,
                      ),
                      width: 28,
                    ),
                    Text(
                      "Hồ sơ",
                      style: TextStyle(
                        color: _currentIndex == 2
                            ? Palette.primary
                            : Palette.darkGrey,
                        fontSize: 10,
                        fontWeight: _currentIndex == 2 ? FontWeight.w500 : null,
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
                room: roomList[0],
                key: Key(roomList[0].id!),
              ),
              itemCount: 5,
            );
          },
          error: (e, stk) => const AppError(),
          loading: () => const AppLoading(),
        );
  }
}
