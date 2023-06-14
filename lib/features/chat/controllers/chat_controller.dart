import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/chat/repositories/chat_repository.dart';
import 'package:study247/utils/show_snack_bar.dart';

final chatControllerProvider = Provider((ref) => ChatController(ref));
final selectingMessageProvider = StateProvider<Message?>((ref) => null);

class ChatController {
  final Ref _ref;
  ChatController(this._ref);

  Future<void> sendMessage({
    required String content,
    bool replying = false,
    String? type,
    String? noteId,
  }) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    var message = Message(
      text: content,
      senderId: user.uid,
      senderName: user.displayName,
      senderPhotoURL: user.photoURL,
      createdAt: DateTime.now().toString(),
      type: type ?? "text",
      noteId: noteId,
    );
    if (replying) {
      final replyingMessage = _ref.read(selectingMessageProvider)!;
      message = message.copyWith(
        replyingName: replyingMessage.senderName,
        replyingPhotoURL: replyingMessage.senderPhotoURL,
        replyingText: replyingMessage.text,
      );
      _ref.read(selectingMessageProvider.notifier).update((state) => null);
    }
    await _ref.read(chatRepositoryProvider).sendMessage(message);
  }

  Future<void> pinMessage(BuildContext context, Message message) async {
    final result = await _ref.read(chatRepositoryProvider).pinMessage(message);
    if (result case Success()) {
      if (context.mounted) showSnackBar(context, "Đã ghim tin nhắn");
    }
  }

  Future<void> unpinMessage(BuildContext context, Message message) async {
    final result =
        await _ref.read(chatRepositoryProvider).unpinMessage(message);
    if (result case Success()) {
      if (context.mounted) showSnackBar(context, "Đã gỡ ghim tin nhắn");
    }
  }
}
