import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/app_error.dart';
import 'package:study247/core/shared/app_loading.dart';
import 'package:study247/features/home/widgets/create_card.dart';
import 'package:study247/features/home/widgets/room_card/room_card.dart';
import 'package:study247/features/room/controllers/room_list_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: const Icon(Icons.menu),
        title: const Text(
          Constants.appName,
          style: TextStyle(),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(roomListControllerProvider.notifier)
            .getRoomList(refresh: true),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateCard(),
              ref.watch(roomListControllerProvider).when(
                    data: (roomList) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            RoomCard(room: roomList[index]),
                        itemCount: roomList.length,
                      );
                    },
                    error: (e, stk) => const AppError(),
                    loading: () => const AppLoading(),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
