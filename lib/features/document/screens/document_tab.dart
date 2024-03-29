import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/document/controllers/document_list_controller.dart';
import 'package:study247/features/document/widgets/document_widget.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

class DocumentTab extends ConsumerWidget {
  const DocumentTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(documentListControllerProvider).when(
          error: (err, stk) => const AppError(),
          loading: () => const AppLoading(),
          data: (documentList) {
            if (documentList.isEmpty) {
              return const Center(
                child: Text(
                  "Trống.",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              );
            }

            final room = ref.watch(roomControllerProvider).asData?.value ??
                RoomModel.empty();
            final notInRoom = room == RoomModel.empty();

            return ListView.builder(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              physics: const BouncingScrollPhysics(),
              itemCount: documentList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return DocumentWidget(
                  document: documentList[index],
                  controlable: notInRoom,
                );
              },
            );
          },
        );
  }
}
