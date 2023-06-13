import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/chat/repositories/chat_repository.dart';

final chatControllerProvider = Provider((ref) => ChatController(ref));
final selectedMessage = StateProvider<Message?>((ref) => null);

class ChatController {
  final Ref _ref;
  ChatController(this._ref);

  Future<void> sendMessage({
    required String content,
    String? type,
    String? noteId,
  }) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    final message = Message(
      text: content,
      senderId: user.uid,
      senderName: user.displayName,
      senderPhotoURL: user.photoURL,
      createdAt: DateTime.now().toString(),
      type: type ?? "text",
      noteId: noteId,
    );
    await _ref.read(chatRepositoryProvider).sendMessage(message);
  }
}
