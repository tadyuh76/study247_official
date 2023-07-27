import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/document/controllers/documents_folder_controller.dart';
import 'package:study247/features/document/widgets/document_widget.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';

class DocumentFromFolderScreen extends ConsumerWidget {
  final String folderName;
  const DocumentFromFolderScreen({
    super.key,
    required this.folderName,
  });

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        title: "Xoá thư mục",
        child: const Text("Thư mục đã xoá sẽ không thể khôi phục lại."),
        onAccept: () => _onDelete(context, ref),
      ),
    );
  }

  void _onDelete(BuildContext context, WidgetRef ref) {
    ref
        .read(documentControllerProvider.notifier)
        .deleteFolder(context, folderName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        actions: [
          IconButton(
            splashRadius: 24,
            onPressed: () => _showDeleteDialog(context, ref),
            icon: SvgPicture.asset(
              IconPaths.trashBin,
              height: 24,
              width: 24,
            ),
          ),
        ],
        title: Text(
          folderName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Column(
          children: [
            ref.watch(documentfolderControllerProvider(folderName)).when(
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

                    return Expanded(
                      child: ListView.builder(
                        itemCount: documentList.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return DocumentWidget(
                            document: documentList[index],
                            controlable: true,
                          );
                        },
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
