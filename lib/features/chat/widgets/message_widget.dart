import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/chat/controllers/chat_controller.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/document/screens/document_edit_screen.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';
import 'package:study247/utils/format_date.dart';

class MessageWidget extends ConsumerWidget {
  final Message message;
  final bool pinned;
  const MessageWidget({
    Key? key,
    required this.message,
    this.pinned = false,
  }) : super(key: key);

  void _onSelect(WidgetRef ref, bool isSelecting) {
    if (isSelecting) {
      ref.read(selectingMessageProvider.notifier).update((state) => null);
    } else {
      ref.read(selectingMessageProvider.notifier).update((state) => message);
    }
  }

  void _onPinMessage(WidgetRef ref, BuildContext context) {
    ref.read(chatControllerProvider).pinMessage(context, message);
  }

  void _onUnpinMessage(WidgetRef ref, BuildContext context) {
    ref.read(chatControllerProvider).unpinMessage(context, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectingMessage = ref.watch(selectingMessageProvider);
    final isSelecting = selectingMessage == message;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    final isReplyMessage = message.replyingName != null;

    return Material(
      color: isSelecting && !pinned ? Palette.lightGrey : Palette.white,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: pinned ? () {} : () => _onSelect(ref, isSelecting),
        child: Container(
          width: maxWidth,
          padding: const EdgeInsets.all(Constants.defaultPadding / 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!pinned && isReplyMessage)
                Row(
                  children: [
                    const SizedBox(width: Constants.defaultPadding / 2),
                    SvgPicture.asset(
                      IconPaths.reply,
                      width: 30,
                      // color: Palette.darkGrey,
                      colorFilter: const ColorFilter.mode(
                        Palette.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: Constants.defaultPadding / 2),
                    Avatar(photoURL: message.replyingPhotoURL!, radius: 8),
                    const SizedBox(width: 5),
                    Text(
                      message.replyingName!,
                      style: const TextStyle(
                        color: Palette.darkGrey,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        message.replyingText?.contains("[TITLE]:") ?? false
                            ? ": Đã gửi một tài liệu."
                            : ": ${message.replyingText}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Palette.darkGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Avatar(photoURL: message.senderPhotoURL, radius: 20),
                  const SizedBox(width: Constants.defaultPadding / 2),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 3),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              message.senderName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!pinned)
                              Text(
                                "  -  ${formatDate(message.createdAt)}",
                                style: const TextStyle(
                                  color: Palette.darkGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            const Spacer(),
                            if (isSelecting && !pinned)
                              GestureDetector(
                                onTap: () => _onPinMessage(ref, context),
                                child: const Text(
                                  "Ghim",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Palette.primary,
                                  ),
                                ),
                              ),
                            if (pinned)
                              GestureDetector(
                                onTap: () => _onUnpinMessage(ref, context),
                                child: SvgPicture.asset(
                                  IconPaths.unpin,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(
                                    Palette.darkGrey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (message.type == "text")
                          Flexible(
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                height: 1.5,
                              ),
                            ),
                          ),
                        if (message.type == "document")
                          _MessageWithDocument(message: message)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageWithDocument extends ConsumerWidget {
  final Message message;

  const _MessageWithDocument({required this.message});

  void _onDocumentTap(BuildContext context, WidgetRef ref) {
    final userId = ref.read(authControllerProvider).asData!.value!.uid;
    if (message.senderId == userId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentEditScreen(documentId: message.noteId!),
        ),
      );
      return;
    }

    ref
        .read(documentControllerProvider.notifier)
        .copyDocument(message.text)
        .then((documentId) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DocumentEditScreen(documentId: documentId),
              ),
            ));
  }

  void _onDocumentHold(WidgetRef ref) {
    if (ref.read(selectingMessageProvider) == null) {
      ref.read(selectingMessageProvider.notifier).update((state) => message);
    } else {
      ref.read(selectingMessageProvider.notifier).update((state) => null);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding / 2),
      child: Material(
        color: Palette.primary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onLongPress: () => _onDocumentHold(ref),
          onTap: () => _onDocumentTap(context, ref),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(Constants.defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_document,
                  color: Palette.white,
                  size: 64,
                ),
                const SizedBox(width: Constants.defaultPadding),
                Expanded(
                  child: Text(
                    message.text
                        .split("[TEXT]:")[0]
                        .substring("[TITLE]:".length),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Palette.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
