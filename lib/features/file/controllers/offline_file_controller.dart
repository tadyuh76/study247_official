import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/file/repositories/offline_file_controller.dart';

final offlineFileControllerProvider =
    StateNotifierProvider<OfflineFileController, PlatformFile?>(
  (ref) => OfflineFileController(ref),
);

class OfflineFileController extends StateNotifier<PlatformFile?> {
  final Ref _ref;
  OfflineFileController(this._ref) : super(null);

  Future<bool> pickFile() async {
    final result = await _ref.read(offlineFileRepositoryProvider).pickFile();

    if (result case Success(value: final file)) {
      state = file;
      return true;
    } else if (result case Failure()) {
      state = null;
    }
    return false;
  }

  void removeFile() {
    state = null;
  }
}
