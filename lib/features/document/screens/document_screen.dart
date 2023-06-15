import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/custom_icon_button.dart';
import 'package:study247/features/document/controllers/document_list_controller.dart';
import 'package:study247/features/document/controllers/folder_list_controller.dart';
import 'package:study247/features/document/widgets/document_create_dialog.dart';
import 'package:study247/features/document/widgets/document_widget.dart';

class DocumentScreen extends ConsumerWidget {
  const DocumentScreen({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DocumentCreateDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: CustomIconButton(
        onTap: () => _showCreateDialog(context),
        backgroundColor: Palette.primary,
        size: 60,
        child: const Icon(
          Icons.add,
          color: Palette.white,
        ),
      ),
      appBar: _renderAppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: const [DocumentTab(), FolderTab()],
      ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      backgroundColor: Palette.white,
      elevation: 0,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tài liệu", style: TextStyle(color: Palette.primary)),
          Text("  -  ", style: TextStyle(color: Palette.darkGrey)),
          Text("Thư mục", style: TextStyle(color: Palette.darkGrey)),
        ],
      ),
    );
  }
}

class DocumentTab extends ConsumerWidget {
  const DocumentTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: SizedBox.expand(
        child: Column(
          children: [
            ref.watch(documentListControllerProvider).when(
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

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return DocumentWidget(document: documentList[index]);
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class FolderTab extends ConsumerWidget {
  const FolderTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: SizedBox.expand(
        child: Column(
          children: [
            ref.watch(folderListControllerProvider).when(
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

                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return DocumentWidget(document: documentList[index]);
                      },
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
