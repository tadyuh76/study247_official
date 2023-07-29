import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';

class NonUserRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String meetingId;
  const NonUserRoomScreen({
    super.key,
    required this.roomId,
    required this.meetingId,
  });

  @override
  ConsumerState<NonUserRoomScreen> createState() => _NonUserRoomScreenState();
}

class _NonUserRoomScreenState extends ConsumerState<NonUserRoomScreen> {
  Future<void> _signInAnonymously() async {
    await ref.read(authControllerProvider.notifier).signInAnonymously(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _signInAnonymously(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (snapshot.hasData) {
          return RoomScreen(
            roomId: widget.roomId,
            meetingId: widget.meetingId,
          );
        }

        return const ErrorScreen();
      },
    );
  }
}
