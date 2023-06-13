import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:photo_view/photo_view.dart';

class FileView extends ConsumerWidget {
  const FileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(fileControllerProvider).when(
          error: (err, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (file) {
            if (file == null) {
              return _renderPickFileUI(ref);
            }

            return file.type == "pdf"
                ? SfPdfViewer.network(file.url)
                : PhotoView(
                    imageProvider: NetworkImage(file.url),
                    backgroundDecoration:
                        const BoxDecoration(color: Palette.grey),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: 2.0,
                  );
          },
        );
  }

  Center _renderPickFileUI(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: ref.read(fileControllerProvider.notifier).pickFile,
            child: Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(Constants.defaultPadding / 2),
              decoration: BoxDecoration(
                color: Palette.lightGrey,
                border: Border.all(width: 4, color: Palette.lightGrey),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              child: SvgPicture.asset(
                IconPaths.fileAdd,
                color: Palette.darkGrey,
              ),
            ),
          ),
          const SizedBox(height: Constants.defaultPadding),
          const SizedBox(
            width: 200,
            child: Text(
              "Nhấn để thêm file ảnh/PDF cho phòng học",
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.black),
            ),
          )
        ],
      ),
    );
  }
}
