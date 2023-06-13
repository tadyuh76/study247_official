import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:study247/constants/common.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/chat/controllers/chat_controller.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';
import 'package:study247/utils/format_date.dart';

class MessageWidget extends ConsumerWidget {
  final Message message;
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  void _onSelect(WidgetRef ref, bool isSelecting) {
    if (isSelecting) {
      ref.read(selectedMessage.notifier).update((state) => null);
    } else {
      ref.read(selectedMessage.notifier).update((state) => message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectingMessage = ref.watch(selectedMessage);
    final isSelecting = selectingMessage == message;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Material(
      color: isSelecting ? Palette.lightGrey : Palette.white,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => _onSelect(ref, isSelecting),
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.all(Constants.defaultPadding / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(photoURL: message.senderPhotoURL, radius: 20),
              const SizedBox(width: Constants.defaultPadding / 2),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          message.senderName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "  -  ${formatDate(message.createdAt)}",
                          style: const TextStyle(
                            color: Palette.darkGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Flexible(
                      child: Text(
                        message.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
