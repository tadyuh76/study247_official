import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/document/controllers/folder_list_controller.dart';
import 'package:study247/features/document/widgets/folder_widget.dart';

class SelectFolderScreen extends ConsumerWidget {
  const SelectFolderScreen({
    super.key,
    required this.documentId,
    required this.onTap,
  });
  final String documentId;
  final void Function(String) onTap;

  void _onFolderTap(BuildContext context, String folderName) {
    onTap(folderName);
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Palette.black,
        centerTitle: true,
        title: const Text(
          "Chọn thư mục",
          style: TextStyle(fontWeight: FontWeight.w500, color: Palette.black),
        ),
      ),
      body: ref.watch(folderListControllerProvider).when(
            error: (err, stk) => const AppError(),
            loading: () => const AppLoading(),
            data: (folderList) {
              if (folderList.isEmpty) {
                return const Center(
                  child: Text("Trống"),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                physics: const BouncingScrollPhysics(),
                itemCount: folderList.length,
                itemBuilder: (context, index) => FolderWidget(
                  folder: folderList[index],
                  selecting: () => _onFolderTap(
                    context,
                    folderList[index].name,
                  ),
                ),
              );
            },
          ),
    );
  }
}
