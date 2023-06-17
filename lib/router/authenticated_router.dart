import 'package:go_router/go_router.dart';
import 'package:study247/features/document/screens/document_edit_screen.dart';
import 'package:study247/features/flashcards/screens/flashcard_screen.dart';
import 'package:study247/features/home/home_screen.dart';
import 'package:study247/features/room/screens/create_room_screen/create_room_screen.dart';
import 'package:study247/features/room/screens/room_screen/room_screen.dart';
import 'package:study247/features/room/screens/solo_room_screen/solo_room_screen.dart';

final authenticatedRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: "create",
          builder: (context, state) => const CreateRoomScreen(),
        ),
        GoRoute(
          path: "room/:roomId/:meetingId",
          builder: (context, state) => RoomScreen(
            roomId: state.pathParameters["roomId"]!,
            meetingId: state.pathParameters["meetingId"]!,
          ),
        ),
        GoRoute(
          path: "document/:id",
          builder: (context, state) =>
              DocumentEditScreen(documentId: state.pathParameters["id"]!),
          routes: [
            GoRoute(
              path: "flashcards",
              builder: (context, _) => const FlashcardScreen(),
            )
          ],
        ),
        GoRoute(
          path: "solo",
          builder: (context, state) => SoloRoomScreen(),
        ),
      ],
    ),
  ],
);
