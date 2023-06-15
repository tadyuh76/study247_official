import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/features/document/controllers/folder_list_controller.dart';
import 'package:study247/features/document/widgets/folder_widget.dart';

class FolderTab extends ConsumerWidget {
  const FolderTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Column(
          children: [
            ref.watch(folderListControllerProvider).when(
                  error: (err, stk) => const AppError(),
                  loading: () => const AppLoading(),
                  data: (folderList) {
                    if (folderList.isEmpty) {
                      return const Center(
                        child: Text(
                          "Trống.",
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: folderList.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FolderWidget(folder: folderList[index]);
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
