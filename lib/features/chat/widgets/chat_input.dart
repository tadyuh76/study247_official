import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/chat/controllers/chat_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';

class ChatInput extends StatelessWidget {
  ChatInput({super.key});

  final _messageController = TextEditingController();

  void _sendMessage(WidgetRef ref) {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final replying = ref.read(selectingMessageProvider) != null;
    ref
        .read(chatControllerProvider)
        .sendMessage(content: content, replying: replying);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MessageReplyBox(),
          const SizedBox(height: Constants.defaultPadding / 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding,
                      vertical: 15,
                    ),
                    hintText: "Nhập tin nhắn của bạn ở đây...",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Palette.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Palette.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Palette.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Constants.defaultPadding / 2),
              Consumer(builder: (context, ref, child) {
                return IconButton(
                  splashRadius: 28,
                  onPressed: () => _sendMessage(ref),
                  icon: const Icon(
                    Icons.send,
                    color: Palette.primary,
                    size: 28,
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}

class MessageReplyBox extends ConsumerWidget {
  const MessageReplyBox({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replyingMessage = ref.watch(selectingMessageProvider);
    if (replyingMessage == null) return const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -5,
          left: 50,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 10,
              height: 10,
              color: Palette.lightGrey,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Palette.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(Constants.defaultPadding / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(photoURL: replyingMessage.senderPhotoURL, radius: 16),
              const SizedBox(width: Constants.defaultPadding / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đang trả lời ${replyingMessage.senderName}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      replyingMessage.text,
                      style: const TextStyle(
                        color: Palette.darkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close_rounded, color: Palette.darkGrey),
                onTap: () => ref
                    .read(selectingMessageProvider.notifier)
                    .update((state) => null),
              )
            ],
          ),
        ),
      ],
    );
  }
}
