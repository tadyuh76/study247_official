import 'package:go_router/go_router.dart';
import 'package:study247/core/shared/widgets/bottom_navigator_wrapper.dart';
import 'package:study247/features/document/screens/document_edit_screen.dart';
import 'package:study247/features/room/screens/create_room_screen/create_room_screen.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';

final authenticatedRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const BottomNavigatorWrapper(),
      routes: [
        GoRoute(
          path: "create",
          builder: (context, state) => const CreateRoomScreen(),
        ),
        GoRoute(
          path: "room/:id",
          builder: (context, state) =>
              RoomScreen(roomId: state.pathParameters["id"]!),
        ),
        GoRoute(
          path: "document/:id",
          builder: (context, state) =>
              DocumentEditScreen(documentId: state.pathParameters["id"]!),
        ),
      ],
    ),
  ],
);
