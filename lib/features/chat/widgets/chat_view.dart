import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/features/chat/controllers/chat_list_controller.dart';
import 'package:study247/features/chat/widgets/chat_input.dart';
import 'package:study247/features/chat/widgets/message_widget.dart';

class ChatView extends ConsumerWidget {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(chatListController).when(
          error: (err, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (chatList) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Text("Trò chuyện"),
                backgroundColor: Palette.white,
              ),
              body: Column(
                children: [
                  Expanded(
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
          },
        );
  }
}
