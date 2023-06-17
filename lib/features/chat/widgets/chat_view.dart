import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/features/chat/controllers/chat_list_controller.dart';
import 'package:study247/features/chat/widgets/chat_input.dart';
import 'package:study247/features/chat/widgets/message_widget.dart';
import 'package:study247/features/chat/widgets/pinned_messages_dialog.dart';

class ChatView extends ConsumerWidget {
  const ChatView({super.key});

  void _showPinnedMessages(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Palette.black.withOpacity(0.3),
      builder: (context) => const PinnedMessagesDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(chatListController).when(
          error: (err, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (chatList) {
            return kIsWeb
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 30,
                      ),
                      child: SizedBox(
                        height: 500,
                        width: 400,
                        child: _renderBaseContent(context, chatList),
                      ),
                    ),
                  )
                : _renderBaseContent(context, chatList);
          },
        );
  }

  Scaffold _renderBaseContent(BuildContext context, List<Message> chatList) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Trò chuyện"),
        backgroundColor: Palette.white,
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () => _showPinnedMessages(context),
            icon: SvgPicture.asset(IconPaths.pin),
          )
        ],
      ),
      body: Column(
        children: [
          chatList.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      "Trống.",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    reverse: true,
                    itemCount: chatList.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding / 2,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) =>
                        MessageWidget(message: chatList[index]),
                  ),
                ),
          ChatInput(),
        ],
      ),
    );
  }
}
