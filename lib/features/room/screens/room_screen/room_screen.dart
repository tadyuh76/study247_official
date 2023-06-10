import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/shared/error_screen.dart';
import 'package:study247/core/shared/loading_screen.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  const RoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  @override
  void initState() {
    super.initState();
    ok();
  }

  Future<void> ok() async {
    await ref
        .read(roomControllerProvider.notifier)
        .getRoomById(context, widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ref.watch(roomControllerProvider).when(
              data: (room) => Text(room!.id.toString()),
              error: (error, stk) => const ErrorScreen(),
              loading: () => const LoadingScreen(),
            ),
      ),
    );
  }
}
