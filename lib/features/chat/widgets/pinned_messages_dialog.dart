import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/chat/controllers/pinned_messages_controller.dart';
import 'package:study247/features/chat/widgets/message_widget.dart';

class PinnedMessagesDialog extends ConsumerWidget {
  const PinnedMessagesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: kToolbarHeight,
          right: Constants.defaultPadding,
        ),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Palette.white,
          child: Container(
            width: 280,
            height: 300,
            padding: const EdgeInsets.symmetric(
              vertical: Constants.defaultPadding,
              horizontal: Constants.defaultPadding / 2,
            ),
            child: ref.watch(pinnedMessagesController).when(
                  error: (err, stk) => const AppError(),
                  loading: () => const AppLoading(),
                  data: (pinnedMessages) {
                    if (pinnedMessages.isEmpty) {
                      return const Column(
                        children: [
                          Text(
                            "Tin nhắn đã ghim",
                            style: TextStyle(
                                fontSize: 16,
                                color: Palette.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Center(
                            child: Text(
                              "Trống.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Text(
                          "Tin nhắn đã ghim",
                          style: TextStyle(
                              fontSize: 16,
                              color: Palette.black,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: Constants.defaultPadding / 2),
                        Expanded(
                          child: ListView.builder(
                            itemCount: pinnedMessages.length,
                            itemBuilder: (context, index) => MessageWidget(
                              message: pinnedMessages[index],
                              pinned: true,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
