import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/file.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/file/repositories/file_repository.dart';

final fileControllerProvider =
    StateNotifierProvider<FileController, AsyncValue<File?>>(
  (ref) => FileController(ref),
);

class FileController extends StateNotifier<AsyncValue<File?>> {
  final Ref _ref;
  FileController(this._ref) : super(const AsyncData(null));

  Future<bool> pickFile({bool solo = false}) async {
    state = const AsyncLoading();
    final result = await _ref.read(fileRepositoryProvider).pickFile(solo: solo);

    if (result case Success(value: final file)) {
      state = AsyncData(file);
      return true;
    } else if (result case Failure()) {
      state = const AsyncData(null);
    }
    return false;
  }

  void removeFile() {
    state = const AsyncData(null);
    _ref.read(fileRepositoryProvider).removeFile();
  }
}
