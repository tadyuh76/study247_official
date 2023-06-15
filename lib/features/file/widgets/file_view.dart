import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/black_background_button.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileView extends ConsumerStatefulWidget {
  const FileView({super.key});

  @override
  ConsumerState<FileView> createState() => _FileViewState();
}

class _FileViewState extends ConsumerState<FileView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref.watch(fileControllerProvider).when(
          error: (err, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (file) {
            if (file == null) {
              return _renderPickFileUI(ref);
            }

            return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              floatingActionButton: _renderActions(ref),
              body: file.type == "pdf"
                  ? SfPdfViewer.network(file.url)
                  : PhotoView(
                      imageProvider: NetworkImage(file.url),
                      backgroundDecoration:
                          const BoxDecoration(color: Palette.grey),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: 2.0,
                    ),
            );
          },
        );
  }

  Padding _renderActions(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding),
      child: Opacity(
        opacity: 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlackBackgroundButton(
                onTap: ref.read(fileControllerProvider.notifier).reset,
                width: 60,
                child: SvgPicture.asset(
                  IconPaths.close,
                  color: Palette.white,
                  width: 32,
                  height: 32,
                )),
            const SizedBox(height: Constants.defaultPadding / 2),
            BlackBackgroundButton(
              onTap: ref.read(fileControllerProvider.notifier).pickFile,
              width: 60,
              child: SvgPicture.asset(
                IconPaths.fileAdd,
                color: Palette.white,
                width: 32,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _renderPickFileUI(WidgetRef ref) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Constants.defaultPadding * 2),
        decoration: BoxDecoration(
          color: Palette.black.withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: ref.read(fileControllerProvider.notifier).pickFile,
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(Constants.defaultPadding / 2),
                decoration: const BoxDecoration(
                  color: Palette.black,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: SvgPicture.asset(
                  IconPaths.fileAdd,
                  color: Palette.lightGrey,
                ),
              ),
            ),
            const SizedBox(height: Constants.defaultPadding),
            const SizedBox(
              width: 200,
              child: Text(
                "Nhấn để thêm file ảnh/PDF cho phòng học",
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.darkGrey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
