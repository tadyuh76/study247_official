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
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/file/controllers/file_controller.dart';
import 'package:study247/features/file/controllers/file_type.dart';
import 'package:study247/features/file/controllers/offline_file_controller.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileView extends ConsumerStatefulWidget {
  final bool solo;
  final bool landscape;
  const FileView({super.key, required this.landscape, this.solo = false});

  @override
  ConsumerState<FileView> createState() => _FileViewState();
}

class _FileViewState extends ConsumerState<FileView> {
  // @override
  // bool get wantKeepAlive => true;

  void _updateFileType() {
    ref.read(fileTypeProvider.notifier).update((state) =>
        state == FileType.offline ? FileType.online : FileType.offline);

    showSnackBar(
      context,
      "Bạn đang xem tệp của ${ref.read(fileTypeProvider) == FileType.offline ? 'cá nhân bạn' : 'phòng học này'}",
    );
  }

  void _pickFile({required bool offline}) {
    offline
        ? ref.read(offlineFileControllerProvider.notifier).pickFile()
        : ref.read(fileControllerProvider.notifier).pickFile();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: widget.landscape ? null : _renderActions(ref),
        body: Builder(
          builder: (context) {
            final isOffline = ref.watch(fileTypeProvider) == FileType.offline;

            if (isOffline) {
              final file = ref.watch(offlineFileControllerProvider);
              if (file == null) return _renderPickFileUI(offline: true);

              return Scaffold(
                backgroundColor: Colors.transparent,
                floatingActionButton: _renderOfflineAction(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
                body: file.extension == "pdf"
                    ? SfPdfViewer.memory(file.bytes!)
                    : PhotoView(
                        imageProvider: MemoryImage(file.bytes!),
                        maxScale: 2.0,
                        minScale: PhotoViewComputedScale.contained,
                        backgroundDecoration: BoxDecoration(
                          color: Palette.black.withOpacity(0.3),
                        ),
                      ),
              );
            }

            final userId = ref.read(authControllerProvider).asData!.value!.uid;
            final hostId =
                ref.read(roomControllerProvider).asData!.value!.hostUid;
            final isHost = userId == hostId;

            return ref.watch(fileControllerProvider).when(
                  error: (err, stk) => const ErrorScreen(),
                  loading: () => const LoadingScreen(),
                  data: (file) {
                    if (file == null) {
                      return isHost ? _renderPickFileUI() : _renderEmptyFile();
                    }

                    return Scaffold(
                      floatingActionButton: _renderOnlineAction(),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerTop,
                      body: file.type == "pdf"
                          ? SfPdfViewer.network(file.url)
                          : PhotoView(
                              maxScale: 2.0,
                              imageProvider: NetworkImage(file.url),
                              minScale: PhotoViewComputedScale.covered,
                              backgroundDecoration: BoxDecoration(
                                color: Palette.black.withOpacity(0.8),
                              ),
                            ),
                    );
                  },
                );
          },
        ),
      ),
    );
  }

  Center _renderEmptyFile() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(Constants.defaultPadding),
          padding: const EdgeInsets.all(Constants.defaultPadding * 2),
          decoration: BoxDecoration(
            color: Palette.black.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chủ phòng chưa ghim tệp",
                style: TextStyle(
                  color: Palette.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(Constants.defaultPadding),
                decoration: BoxDecoration(
                  color: Palette.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                child: SvgPicture.asset(
                  IconPaths.fileUnknown,
                  colorFilter: const ColorFilter.mode(
                    Palette.lightGrey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              const SizedBox(
                width: 200,
                child: Text(
                  "Chủ phòng học hiện tại\n chưa ghim file ảnh/PDF nào.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.darkGrey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderOfflineAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10 + 60, right: 10),
          child: BlackBackgroundButton(
            width: 60,
            onTap: ref.read(offlineFileControllerProvider.notifier).removeFile,
            child: SvgPicture.asset(
              IconPaths.close,
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderOnlineAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10 + 60, right: 10),
          child: BlackBackgroundButton(
            width: 60,
            onTap: ref.read(fileControllerProvider.notifier).removeFile,
            child: SvgPicture.asset(
              IconPaths.close,
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderActions(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 10),
          child: BlackBackgroundButton(
            width: 60,
            onTap: _updateFileType,
            child: SvgPicture.asset(
              IconPaths.fileChange,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderPickFileUI({bool offline = false}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(Constants.defaultPadding),
          padding: const EdgeInsets.all(Constants.defaultPadding * 2),
          decoration: BoxDecoration(
            color: Palette.black.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                offline ? "Ghim ảnh/PDF cá nhân" : "Ghim ảnh/PDF cho phòng học",
                style: const TextStyle(
                  color: Palette.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              GestureDetector(
                onTap: () => _pickFile(offline: offline),
                child: Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Palette.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: SvgPicture.asset(
                    IconPaths.fileAdd,
                    colorFilter: const ColorFilter.mode(
                      Palette.lightGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              SizedBox(
                width: 200,
                child: Text(
                  "Nhấn để thêm file ảnh/PDF\n cho ${offline ? "cá nhân bạn" : "phòng học"}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Palette.darkGrey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
